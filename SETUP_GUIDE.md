# คู่มือตั้งค่า CI/CD แบบครบขั้นตอน

> ยังไม่ควรใส่รหัสผ่าน, token หรือ private key ลงในไฟล์ใด ๆ ใน repository

## 1. สิ่งที่ต้องมี

- GitHub account และ repository สำหรับงานนี้
- Docker Hub account และ public repository ชื่อ `tni-cicd-gcp`
- Google Cloud project ที่เปิดใช้งาน Compute Engine และ Billing แล้ว
- Compute Engine VM ที่มี External IP และเปิด TCP port 80

## 2. สร้างหรือเตรียม VM

ทางเลือก A: ใช้ Cloud Shell และรันสคริปต์สร้าง VM

```bash
export PROJECT_ID="YOUR_GCP_PROJECT_ID"
chmod +x infra/create-vm.sh
./infra/create-vm.sh
```

สคริปต์ใช้ค่าเริ่มต้นดังนี้:

- VM: `tni-cicd-vm`
- Zone: `asia-southeast1-b`
- Machine type: `e2-micro`
- OS: Ubuntu 24.04 LTS
- เปิด HTTP port 80

เครื่อง VM อาจมีค่าใช้จ่าย ควรหยุดหรือลบเมื่อส่งงานเสร็จ และตั้ง Budget Alert ใน GCP

ทางเลือก B: ถ้ามี VM แล้ว ให้ SSH เข้า VM แล้วรัน:

```bash
chmod +x infra/prepare-vm.sh
./infra/prepare-vm.sh
```

ออกจากระบบแล้ว login ใหม่ จากนั้นตรวจด้วย `docker ps`

## 3. สร้าง SSH key สำหรับ GitHub Actions

สร้าง key แยกสำหรับงานนี้บนเครื่องที่ปลอดภัย:

```bash
ssh-keygen -t ed25519 -C "github-actions-tni-cicd" -f ./tni-cicd_deploy_key
```

นำเนื้อหา `tni-cicd_deploy_key.pub` ไปเพิ่มในไฟล์ `~/.ssh/authorized_keys` ของ user บน VM

ทดสอบ login ด้วย private key ให้สำเร็จก่อน:

```bash
ssh -i ./tni-cicd_deploy_key VM_USER@VM_EXTERNAL_IP
```

## 4. สร้าง Docker Hub access token

ใน Docker Hub ไปที่ Account settings > Personal access tokens แล้วสร้าง token แบบ Read & Write สำหรับ CI/CD

## 5. เพิ่ม GitHub Actions Secrets

ไปที่ GitHub repository > Settings > Secrets and variables > Actions > New repository secret

สร้างทั้งหมด 5 ค่า:

| Secret | ค่า |
|---|---|
| `DOCKERHUB_USERNAME` | ชื่อผู้ใช้ Docker Hub |
| `DOCKERHUB_TOKEN` | Docker Hub access token |
| `VM_HOST` | External IP ของ GCP VM |
| `VM_USER` | Linux user ที่ SSH เข้า VM ได้และอยู่ในกลุ่ม `docker` |
| `VM_SSH_KEY` | เนื้อหาทั้งหมดของ private key `tni-cicd_deploy_key` |

## 6. Push โปรเจกต์ขึ้น GitHub

```bash
git init
git branch -M main
git add .
git commit -m "feat: add GCP CI/CD pipeline"
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/tni-cicd-gcp.git
git push -u origin main
```

การ push ครั้งแรกจะ trigger workflow ทันที ถ้า Secrets และ VM พร้อมแล้ว งานควรผ่านทั้งสอง jobs

## 7. ตรวจผล

1. GitHub > Actions > `Build, Push and Deploy` ต้องเป็นสีเขียว
2. Docker Hub ต้องเห็น tag `latest` และ tag commit SHA
3. เปิด `http://VM_EXTERNAL_IP` ต้องเห็นหน้าเว็บ
4. เปิด `http://VM_EXTERNAL_IP/health` ต้องแสดง `ok`

## 8. ทดสอบการแก้โค้ดตามโจทย์

แก้ข้อความใน `index.html` ตรง `hero__title` แล้ว:

```bash
git add index.html
git commit -m "demo: change homepage message"
git push origin main
```

รอ pipeline สำเร็จแล้ว refresh หน้าเว็บ ข้อความใหม่ต้องปรากฏโดยไม่ต้อง login เข้า VM เพื่อ deploy เอง

## 9. แก้ปัญหาที่พบบ่อย

- `Permission denied (publickey)` - ตรวจ `VM_USER`, public key ใน `authorized_keys` และ private key ใน `VM_SSH_KEY`
- `permission denied /var/run/docker.sock` - เพิ่ม user เข้า group `docker` แล้ว logout/login ใหม่
- เข้าเว็บไม่ได้ - ตรวจ firewall port 80, External IP และ container ด้วย `docker ps`
- Docker Hub login ไม่ผ่าน - ใช้ access token ไม่ใช่รหัสผ่าน และตรวจชื่อ secret ให้ตรง
- Workflow ผ่าน build แต่ deploy ไม่ผ่าน - ทดสอบ SSH จากเครื่องก่อน แล้วดู log ขั้น `Configure SSH`
