# TNI Cloud Computing - Assignment 06

ตัวอย่าง CI/CD Pipeline บน Google Cloud Platform ตามโจทย์สัปดาห์ที่ 10

เมื่อ push ไปที่ branch `main` ระบบจะทำงานตามลำดับนี้:

1. GitHub Actions ตรวจไฟล์และ build Docker image
2. Push image ไป Docker Hub ทั้ง tag `latest` และ commit SHA
3. Login เข้า Google Cloud VM ผ่าน SSH
4. Pull image เวอร์ชันใหม่
5. ลบ container เดิมและรัน container ใหม่ที่ port 80
6. ตรวจ `http://VM_IP/health` ว่าตอบกลับสำเร็จ

## โครงสร้างไฟล์

- `index.html` - หน้าเว็บสำหรับแก้ข้อความตอนสาธิต
- `Dockerfile` และ `nginx.conf` - package เว็บเป็น Nginx container
- `.github/workflows/cicd.yml` - CI/CD Pipeline
- `infra/create-vm.sh` - ตัวช่วยสร้าง Compute Engine VM
- `infra/prepare-vm.sh` - ติดตั้ง Docker บน VM ที่มีอยู่แล้ว
- `SETUP_GUIDE.md` - คู่มือตั้งค่าบัญชี, VM และ GitHub Secrets
- `VIDEO_SCRIPT.md` - ลำดับการอัดวิดีโอไม่เกิน 5 นาที

## ทดสอบบนเครื่อง

```bash
docker build -t tni-cicd-gcp:local .
docker run --rm -p 8080:80 tni-cicd-gcp:local
```

เปิด `http://localhost:8080` และตรวจสุขภาพที่ `http://localhost:8080/health`

## จุดที่แก้ตอนอัดวิดีโอ

ใน `index.html` ค้นหา `hero__title` แล้วเปลี่ยนข้อความ เช่น:

```html
<h1 class="hero__title">CI/CD Updated Successfully!</h1>
```

จากนั้น commit และ push:

```bash
git add index.html
git commit -m "demo: update homepage message"
git push origin main
```

ดู GitHub Actions ทำงานจนสำเร็จ แล้ว refresh หน้าเว็บจาก External IP ของ VM เพื่อแสดงข้อความใหม่
