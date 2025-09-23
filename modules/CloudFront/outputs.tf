

output "cloudfront_domain_name" {
  description = "CloudFront distribution URL for ALB"
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cloudfront.id
}
