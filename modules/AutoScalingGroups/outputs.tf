output "asg_id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.ASG_terraform.id
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.ASG_terraform.name
}
output "asg_instance_ids" {
  description = "List of EC2 instance IDs in the ASG"
  value       = data.aws_instances.asg_instances.ids
}
output "attached_target_groups" {
  description = "The target groups attached to the ASG"
  value       = aws_autoscaling_group.ASG_terraform.target_group_arns
}
