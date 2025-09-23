variable "instance_type" {
  description = "intance type"
  type        = string
  default     = "t2.micro"

}

variable "credentials_file" {
  description = "credentials file"
  type        = string
  default     = "C:\\Users\\91949\\Desktop\\keys\\terraform_key.pub"

}

variable "region" {
  description = "region of the ami"
  type        = string
  default     = "us-east-1"

}
