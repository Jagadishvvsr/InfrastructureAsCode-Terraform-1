resource "aws_lb" "ALB_lb_tf" {
  name               = "ALb-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load_balancer_sg_id]
  subnets            = var.vpc_public_subnets

  enable_deletion_protection = true

  /* access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  } */

  tags = {
    Environment = var.Environment
  }
}


resource "aws_lb_target_group" "ASG_as_target_blue" {
  name     = "tf-lb-tg-blue-${var.Environment}"
  port     = var.protocol_port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    port = var.protocol_port
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200-299"
  }
  tags = {
    Environment = var.Environment
  }
}


resource "aws_lb_target_group" "ASG_as_target_green" {
  name     = "tf-lb-tg-green-${var.Environment}"
  port     = var.protocol_port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    port = var.protocol_port
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    matcher              = "200-299"
  }
  tags = {
    Environment = var.Environment
  }
}

resource "aws_lb_listener" "ALB-listener" {
  load_balancer_arn = aws_lb.ALB_lb_tf.arn
  port              = var.protocol_port
  protocol          = var.protocol
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type = "forward"

    forward {
      stickiness {
        enabled  = true
        duration = 60
      }
      target_group {
        arn    = aws_lb_target_group.ASG_as_target_blue.arn
        weight = var.weight_blue
      }
      target_group {
        arn    = aws_lb_target_group.ASG_as_target_green.arn
        weight = var.weight_green
      }
    }
  }
}