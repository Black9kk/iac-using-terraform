# main.tf

# Cấu hình Provider AWS
provider "aws" {
  region = "ap-southeast-1" # Thay thế bằng region mong muốn của bạn (ví dụ: us-east-1, eu-west-1)
}

# Cấu hình Backend S3
terraform {
  backend "s3" {
    bucket         = "black-dev-my-terraform-state-bucket-12345" # Thay thế bằng tên S3 bucket của bạn
    key            = "ec2/terraform.tfstate"            # Đường dẫn file tfstate trong bucket
    region         = "ap-southeast-1"                   # Thay thế bằng region của bucket S3
    dynamodb_table = "my-terraform-lock-table"          # Thay thế bằng tên DynamoDB table của bạn
    encrypt        = true                               # Mã hóa trạng thái trong S3
  }
}

resource "aws_key_pair" "udemy-keypair" {
  key_name   = "udemy-keypair"
  public_key = file("./keypair/udemy-key.pub")
}

resource "aws_instance" "demo-instance" {
  ami                     = "ami-05ab12222a9f39021"
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.udemy-keypair.key_name
  tags = {
    Name = "Udemy Demo"
  }
  vpc_security_group_ids = [ aws_security_group.test-security-group.id ]
}

resource "aws_security_group" "test-security-group" {
  name        = "test-security-group"
  description = "test-security-group"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
