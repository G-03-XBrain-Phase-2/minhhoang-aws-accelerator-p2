variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_type" {
  type        = string
  description = "The type of instance to use for the EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to launch the EC2 instance in"
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to associate with the EC2 instance"
}
