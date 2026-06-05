variable "tags" {
  type    = map(string)
  default = {}
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The IDs of the public subnets to associate with the ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "The ID of the security group to associate with the ALB"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to associate with the ALB"
}

variable "instance_id" {
  type        = string
  description = "The ID of the EC2 instance to register with the ALB"
}
