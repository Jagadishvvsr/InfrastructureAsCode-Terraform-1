output "primary_bucket_name" {
  value = aws_s3_bucket.primary_bucket.bucket
}

output "replica_bucket_name" {
  value = aws_s3_bucket.replica_bucket.bucket
}

output "replication_role_arn" {
  value = aws_iam_role.replication.arn
}

output "primary_bucket_arn" {
  value = aws_s3_bucket.primary_bucket.arn
}