terraform {
  required_version = ">=1.10"

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

module "data" {
  source        = "./modules"
  name_prefix   = "my-s3-bucket-"
  versioning    = true
  force_destroy = true
  tags = {
    Purpose = "data"
  }
}

module "logs" {
  source        = "./modules"
  name_prefix   = "my-s3-logs-bucket-"
  versioning    = false
  force_destroy = false
  tags = {
    Purpose = "logs"
  }
}

output "logs" {
  value = module.logs.id
}

output "data" {
  value = module.data.id
}
