terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# 1. ค้นหา AMI อัตโนมัติ
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# 2. Security Group (เปิดพอร์ต 3020 ตามโค้ดอาจารย์)
resource "aws_security_group" "exam_sg" {
  name        = "quiz2-sg-66310608"
  description = "Allow Port 80 and 3020"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3020
    to_port     = 3020
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.exam_sg.id]

  user_data = <<-EOD
              #!/bin/bash
              sudo apt-get update
              curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
              sudo apt-get install -y nodejs git
              
              cd /home/ubuntu
              git clone https://github.com/Gurkkiat/devops68-compound-interest.git app
              
              cd app
              npm install
              # ใช้ npm start เพราะใน package.json ตั้งไว้ให้รัน index.js แล้ว
              npm start &
              EOD

  tags = {
    Name = "Quiz2-66310608"
  }
}

# 4. Output URL (เปลี่ยนเป็นพอร์ต 3020)
output "app_url" {
  value = "http://${aws_instance.app_server.public_ip}:3020/calculate?principal=1000&rate=5&time=2&compound=12"
}