# Bucket names
variable "primary_bucket_name" {
  description = "Primary bucket base name"
  type        = string
  default     = "vvsr-primary"
}

variable "replica_bucket_name" {
  description = "Replica bucket base name"
  type        = string
  default     = "vvsr-replica"
}

# Regions
variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "replica_region" {
  type    = string
  default = "eu-central-1"
}