locals {
  common_tags = merge(var.tags, {
    Project = "Capstone-w8"
    Owner   = "minhhoang"
  })
}

resource "aws_lb" "main" {
  name                       = "capstone-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  tags = local.common_tags
}

resource "aws_lb_target_group" "main" {
  name     = "capstone-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "8080"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = local.common_tags
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = var.instance_id
  port             = 8080
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
