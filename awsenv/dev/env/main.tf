# main.tf

# Cấu hình Provider AWS
provider "aws" {
  region = "ap-southeast-1" # Thay thế bằng region mong muốn của bạn (ví dụ: us-east-1, eu-west-1)
}


# Cấu hình Backend S3
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-lock-dev" # Thay thế bằng tên S3 bucket của bạn
    key            = "terraform.tfstate"            # Đường dẫn file tfstate trong bucket
    region         = "ap-southeast-1"                   # Thay thế bằng region của bucket S3
    dynamodb_table = "my-terraform-lock-table-dev"          # Thay thế bằng tên DynamoDB table của bạn
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
 vpc_security_group_ids = [data.aws_security_group.default.id]
}

resource "aws_instance" "demo-instance-2" {
  ami                     = "ami-05ab12222a9f39021"
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.udemy-keypair.key_name
  tags = {
    Name = "Udemy Demo"
  }
  vpc_security_group_ids = ["sg-06df41a900f2d3085"]
}


# Lấy VPC mặc định
data "aws_vpc" "default" {
  default = true
}

# Lấy security group mặc định của VPC đó
data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}