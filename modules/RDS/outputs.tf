output "db_endpoint" {
  description = "DNS address of the RDS instance (use this in your app connection string)"
  value       = aws_db_instance.tf_postgre_db.endpoint
}

output "db_port" {
  description = "Port number of the RDS instance"
  value       = aws_db_instance.tf_postgre_db.port
}

output "db_name" {
  description = "Initial database name created inside the RDS instance"
  value       = aws_db_instance.tf_postgre_db.db_name
}

output "db_username" {
  description = "Master username for the RDS instance (password stored securely in Secrets Manager)"
  value       = aws_db_instance.tf_postgre_db.username
  sensitive   = true
}

output "db_instance_arn" {
  description = "ARN of the RDS instance, useful for IAM policies/monitoring"
  value       = aws_db_instance.tf_postgre_db.arn
}
