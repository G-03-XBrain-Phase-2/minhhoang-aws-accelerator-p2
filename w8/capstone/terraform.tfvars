cidr_block = "10.0.0.0/16"

ingress_rule_alb = [{
  port        = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
  },
  {
    port        = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
}]

ingress_rule_ec2 = [{
  port        = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SSH"
  }, {
  port        = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
  }
]

instance_type = "c7i-flex.large"
