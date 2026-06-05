terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "default"
}

provider "tls" {}

provider "local" {}



module "vpc" {
  source = "./modules/vpc"

  tags             = var.tags
  cidr_block       = var.cidr_block
  ingress_rule_alb = var.ingress_rule_alb
  ingress_rule_ec2 = var.ingress_rule_ec2

}

module "ec2" {
  source = "./modules/ec2"

  tags              = var.tags
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.ec2_sg_id
}

module "alb" {
  source = "./modules/alb"

  tags              = var.tags
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.vpc.alb_sg_id
  vpc_id            = module.vpc.vpc_id
  instance_id       = module.ec2.instance_id

  depends_on = [module.ec2]
}
