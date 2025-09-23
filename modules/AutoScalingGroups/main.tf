


resource "aws_autoscaling_group" "ASG_terraform" {
  vpc_zone_identifier = [var.subnet_private1a , var.subnet_private1b]
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  instance_maintenance_policy {
    min_healthy_percentage = 75
    max_healthy_percentage = 120
  }
  default_instance_warmup = 30

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
  
  target_group_arns = [
    var.tg_blue_arn , 
    # var.tg_green_arn   # optional for future blue/green deployments
  ]

  tag {
    key                 = "Environment"
    value               = var.tags
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 75
    }
  }
}

# Data source: query EC2 instances inside that ASG
data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ASG_terraform.name]
  }
}

