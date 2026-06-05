variable "tags" {
  type    = map(string)
  default = {}
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "ingress_rule_alb" {
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "ingress_rule_ec2" {
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "instance_type" {
  type        = string
  description = "The type of instance to use for the EC2 instance"
}
