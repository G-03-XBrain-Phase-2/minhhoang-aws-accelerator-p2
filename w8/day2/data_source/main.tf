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

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "The AWS account ID of the current caller"
}

output "availability_zones" {
  value       = data.aws_availability_zones.available.names
  description = "List of available availability zones in the region"
}

output "ubuntu_ami_id" {
  value       = data.aws_ami.ubuntu.id
  description = "The ID of the most recent Amazon Linux 2023 AMI"
}

# for loop in local value
locals {
  web_ports = [for p in var.allowed_ports : p if p != 32]

  port_desc = { for p in var.allowed_ports : p => "cho phép cổng ${p}" }

}

data "aws_vpc" "default" {
  default = true
}


# dynamic block
resource "aws_security_group" "web" {
  name_prefix = "web-sg-"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.web_ports
    content {
      description = "HTTP/HTTPS ${ingress.value}"
      # support Port range, from -> to, example: 80-90, then from_port = 80, to_port = 90
      from_port = ingress.value
      to_port   = ingress.value

      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}
