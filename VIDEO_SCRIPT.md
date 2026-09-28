# สคริปต์อัดวิดีโอไม่เกิน 5 นาที

## 0:00-0:30 - แนะนำงาน

- บอกชื่องาน: Cloud Computing Assignment 06 - CI/CD on Google Cloud Platform
- อธิบาย flow สั้น ๆ: GitHub > Build Docker > Docker Hub > SSH เข้า GCP VM > Pull/Run container

## 0:30-1:10 - แสดงสถานะก่อนแก้

- เปิดหน้าเว็บจาก External IP ของ VM
- เปิดไฟล์ `index.html` และชี้ข้อความ `Hello from CI/CD Pipeline`
- เปิด GitHub Actions ให้เห็น workflow เดิมที่ผ่าน

## 1:10-1:50 - แก้โค้ดและ push

- เปลี่ยนข้อความ `hero__title` เป็น `CI/CD Updated Successfully!`
- แสดงเฉพาะคำสั่ง `git add`, `git commit`, `git push`
- ระวังไม่ให้ private key, token หรือหน้าจอ Secrets ปรากฏในวิดีโอ

## 1:50-3:30 - แสดง Pipeline

- เปิด GitHub Actions run ที่เกิดจาก push
- ชี้ขั้นสำคัญ: checkout, login Docker Hub, build/push image, configure SSH, deploy, health check
- ระหว่างรอ อธิบายว่า image มีทั้ง tag `latest` และ commit SHA

## 3:30-4:20 - ตรวจ Docker Hub และ VM

- แสดง Docker Hub repository และ tag ล่าสุด
- แสดงว่า deploy job สำเร็จ
- ไม่ต้องเปิดเผย token หรือ private key

## 4:20-4:50 - แสดงผลหลัง deploy

- Refresh หน้าเว็บจาก External IP
- แสดงข้อความใหม่ `CI/CD Updated Successfully!`
- เปิด `/health` ให้เห็น `ok`

## 4:50-5:00 - สรุป

- สรุปว่าเพียงแก้ code และ push ระบบ build, push และ deploy อัตโนมัติครบ

## เช็กลิสต์ก่อนอัด

- ปิด notification ที่อาจแสดงข้อมูลส่วนตัว
- ซ่อน bookmark/email/tab ที่ไม่เกี่ยวข้อง
- ขยายตัวอักษรให้เห็นชัด
- เตรียมข้อความที่จะเปลี่ยนไว้แล้ว
- ตรวจว่า VM ทำงาน, GitHub Secrets ครบ และ Docker Hub repository เป็น public
- ลอง pipeline ให้ผ่านหนึ่งรอบก่อนอัดจริง
