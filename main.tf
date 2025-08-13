# Terraform AWS Provider 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS 지역 설정
provider "aws" {
  region = "us-east-1" # 원하는 지역으로 변경 가능합니다.
}

# 최신 Amazon Linux 2 AMI 조회
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 웹 트래픽(80) 및 SSH(22)를 허용하는 보안 그룹 생성
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "HTTP와 SSH 인바운드 트래픽을 허용합니다"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 보안을 위해 실제 IP 주소로 제한하는 것이 좋습니다.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-security-group"
  }
}

# EC2 인스턴스 생성
resource "aws_instance" "nginx_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro" # AWS 프리티어에 해당됩니다.
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  # User Data: 인스턴스 시작 시 Nginx 설치 및 실행
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "nginx-web-server"
  }
}

# EC2 인스턴스의 퍼블릭 IP 주소 출력
output "public_ip" {
  value       = aws_instance.nginx_server.public_ip
  description = "Nginx 웹 서버의 퍼블릭 IP 주소입니다."
}
