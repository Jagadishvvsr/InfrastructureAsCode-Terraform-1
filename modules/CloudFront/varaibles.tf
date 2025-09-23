variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB origin"
  type        = string
}

variable "alb_id" {
  description = "ID of the ALB origin"
  type        = string
}

variable "waf_arn" {
  description = "WAF ARN to attach to CloudFront"
  type        = string
  default     = ""
}

variable "api_path_pattern" {
  description = "Path pattern for API caching behavior"
  type        = string
  default     = "/api/*"
}

variable "static_path_pattern" {
  description = "Path pattern for static content caching behavior"
  type        = string
  default     = "/*"
}

variable "default_ttl" {
  description = "Default TTL for CloudFront caching"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Max TTL for CloudFront caching"
  type        = number
  default     = 86400
}

variable "min_ttl" {
  description = "Min TTL for CloudFront caching"
  type        = number
  default     = 0
}

