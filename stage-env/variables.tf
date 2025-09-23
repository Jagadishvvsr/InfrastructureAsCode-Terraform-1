variable "environment" {
    description = "Environment type"
    type = string 
    default = "TEST"
}

variable "custom_ami_image" {
    description = "AMI image id "
    type = string
}

variable "instance_type" {
    description = "Instance type"
    type = string
    default = "t2.micro"
}

variable "launch_instance_type" {
   description = "launch instance type"
   type = string
   default = "t2.micro"

}

variable "pub_key" {
   description = "public key"
   type = string
   default = "C:/Users/91949/Desktop/keys/terraform_key.pub"
}

variable "max_size" {
    description = "maximum size of auto scaling"
    type = number 
    default = 2
}

variable "min_size" {
   description = "minimum size of auto scaling"
   type = string
   default = "1"
}

variable "desired_capacity" {
    description = "desired capacity of auto scaoling"
    type = number
    default = 1
}

variable "tags" {
    description = "instance tags"
    type= string
    default = "TEST"
}

variable "protocol" {
    description = "type of protocol"
    type = string
    default = "HTTP"
}

variable "protocol_port" {
    description = "Protocol port"
    type = string
    default = "80"
}

variable "weight_blue" {
    description = "weight for ALB routing to target group/blue"
    type = string
    default = "100"
}

variable "weight_green" {
    description = "weight for ALB routing to target group/green"
    type = string
    default = "0"
}


variable "db_instance_class" {
    description = "database instance class"
    type = string
    default = "db.t3.micro"
}

variable "Storage_allocation" {
    description = "Necessary storage of DB"
    type = string
    default = "10"

}

variable "AZ_availability" {
    description = "Multi AZ availability"
    type = bool
    default = false
}

variable "storage_type" {
    description = "DB storage type"
    type = string
    default = "gp2"
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

