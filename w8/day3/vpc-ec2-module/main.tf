terraform {
  required_version = ">=1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "default"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

module "network" {
  source = "./modules/network"

  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnet = {
    (data.aws_availability_zones.available.names[0]) = "10.0.1.0/24"
    (data.aws_availability_zones.available.names[1]) = "10.0.2.0/24"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"
  subnet_id     = module.network.public_subnet_ids[0]

  tags = {
    Name = "WebServer"
  }
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.network.public_subnet_ids
}
