output "alb_id" {
  value       = aws_lb.ALB_lb_tf.id
  description = "The ID of the Application Load Balancer"
}

output "alb_arn" {
  value       = aws_lb.ALB_lb_tf.arn
  description = "The ARN of the Application Load Balancer"
}
output "alb_dns_name" {
  value       = aws_lb.ALB_lb_tf.dns_name
  description = "DNS name of the ALB"
}

output "tg_blue_arn" {
  value = aws_lb_target_group.ASG_as_target_blue.arn
}

output "tg_green_arn" {
  value  = aws_lb_target_group.ASG_as_target_green.arn
}