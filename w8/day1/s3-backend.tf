terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "default"
}

resource "aws_s3_bucket" "local" {
  bucket_prefix = "s3-backend-"
  force_destroy = true

  tags = {
    Environment = "Dev"
    Owner       = "Minh Hoang"
  }
}

resource "aws_s3_bucket_versioning" "local" {
  bucket = aws_s3_bucket.local.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "local" {
  bucket = aws_s3_bucket.local.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "local" {
  bucket = aws_s3_bucket.local.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.local.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.local.arn
}
