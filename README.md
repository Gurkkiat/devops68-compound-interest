# 📈 Compound Interest Calculator API (DevOps Quiz 2)

**ชื่อ:** Kerkerk Taweekwan  
**รหัสนักศึกษา:** 66310608  
**รายวิชา:** DevOps Engineering  

โปรเจกต์นี้ประกอบด้วย Infrastructure as Code (Terraform) และแอปพลิเคชัน Node.js สำหรับคำนวณดอกเบี้ยทบต้น โดยสามารถทำตามขั้นตอนด้านล่างเพื่อสร้างระบบและ deploy แอปได้ครบถ้วน

---

## 🎯 สิ่งที่ต้องมีก่อนเริ่ม (Prerequisites)

ก่อนเริ่มใช้งาน ต้องติดตั้งและตั้งค่าดังนี้:

- **Terraform** (เวอร์ชัน 1.0.0 ขึ้นไป)
- **AWS CLI** (ตั้งค่าด้วยคำสั่ง `aws configure`)
- **Git**

---

## 🏗️ ขั้นตอนที่ 1: สร้าง Infrastructure (2 คะแนน)

ไฟล์ `main.tf` จะใช้สำหรับสร้าง AWS EC2 (Ubuntu 22.04) พร้อม Security Group ที่เปิดพอร์ต:
- SSH (22)
- HTTP (80)
- API (3020)

### 1. Clone โปรเจกต์
```bash
git clone https://github.com/Gurkkiat/devops68-compound-interest.git
cd devops68-compound-interest
```

### 2. เริ่มต้น Terraform
```bash
terraform init
```

### 3. สร้าง Infrastructure
```bash
terraform apply -auto-approve
```

### 4. ดู Public IP
เมื่อทำเสร็จ Terraform จะโชว์ `app_url`  
ให้จด `<EC2_PUBLIC_IP>` ไว้ใช้ในขั้นตอนถัดไป

---

## 🚀 ขั้นตอนที่ 2: Deploy และรันโปรเจกต์ (5 คะแนน)

### 1. SSH เข้า EC2
```bash
ssh -i <your-key.pem> ubuntu@<EC2_PUBLIC_IP>
```

### 2. ติดตั้ง dependencies
```bash
cd /home/ubuntu/app
sudo npm install
```

### 3. รันแอปแบบ Background (ไม่ปิดแม้ logout)
```bash
nohup node index.js > output.log 2>&1 &
```

> กด Enter เพื่อกลับมาที่ command line  
> แอปจะทำงานที่พอร์ต **3020**

---

## 🧪 ขั้นตอนที่ 3: ทดสอบ API

### วิธีที่ 1: ทดสอบในเครื่อง EC2 (แนะนำ)
```bash
curl "http://localhost:3020/calculate?principal=1000&rate=5&time=2&compound=12"
```

### วิธีที่ 2: ทดสอบผ่าน Browser หรือ Postman
```
http://<EC2_PUBLIC_IP>:3020/calculate?principal=1000&rate=5&time=2&compound=12
```

### ✅ ผลลัพธ์ที่ควรได้
```json
{
  "principal": 1000,
  "rate": 5,
  "time": 2,
  "compound": 12,
  "compoundInterest": 104.94,
  "total": 1104.94
}
```

---

## 🛠️ การแก้ปัญหา (Network / Port Blocking)

หากเข้าไม่ได้และขึ้น `ERR_CONNECTION_TIMED_OUT`  
อาจเกิดจากเครือข่าย (เช่น Wi-Fi มหาวิทยาลัย) บล็อกพอร์ต **3020**

### 🔧 วิธีแก้: เปลี่ยนจากพอร์ต 80 → 3020
ให้รันคำสั่งนี้ใน EC2:

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3020
```

### จากนั้นเข้าใช้งานผ่าน:
```
http://<EC2_PUBLIC_IP>/calculate?principal=1000&rate=5&time=2&compound=12
```

---

## ✅ หมายเหตุเพิ่มเติม
- ต้องเปิดพอร์ตใน Security Group: **22, 80, 3020**
- ตั้งค่า permission ของไฟล์ `.pem`:

```bash
chmod 400 <your-key.pem>
```

---

🎉 ตอนนี้ API สำหรับคำนวณดอกเบี้ยทบต้นของคุณพร้อมใช้งานแล้ว!
