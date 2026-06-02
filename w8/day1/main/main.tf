terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "s3-backend-20260602034907737900000001"
    key          = "./terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
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
