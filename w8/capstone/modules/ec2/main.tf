locals {
  common_tags = merge(var.tags, {
    Project = "Capstone-w8"
    Owner   = "minhhoang"
  })
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  key_name   = "capstone-key"
  public_key = tls_private_key.main.public_key_openssh

  tags = local.common_tags
}

resource "local_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = pathexpand("~/.ssh/capstone-key.pem")
  file_permission = "400"
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  key_name = aws_key_pair.main.key_name

  user_data = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = local.common_tags

}
