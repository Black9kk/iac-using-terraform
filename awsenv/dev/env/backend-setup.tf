# backend_setup.tf

# resource "aws_key_pair" "udemy-keypair" {
#   key_name   = "udemy-keypair"
#   public_key = file("./keypair/udemy-key.pub")
# }

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "my-terraform-state-lock-dev" # Thay thế bằng tên bucket duy nhất của bạn

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "dev01-waf-log-testing" {
  bucket = "dev01-waf-log-testing" # Thay thế bằng tên bucket duy nhất của bạn

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}


resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "my-terraform-lock-table-dev" # Thay thế bằng tên bảng DynamoDB của bạn
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "Dev"
  }
}
