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
  bucket_prefix = "local-bucket-"
  force_destroy = true

  tags = {
    Environment = "Dev"
    Owner       = "Minh Hoang"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.local.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.local.arn
}
