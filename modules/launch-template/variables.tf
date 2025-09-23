variable "custom_ami_image" {
    description = "AMI image"
    type = string
}

variable "launch_instance_type" {
   description = "launch instance type"
   type = string
   default = "t2.micro"

}


/* variable "launch_template_sg" {
   description = "launch instance secuirity group"
   type = string
} */

variable "pub_key" {
  description = "public key"
  type = string
  default = "C:/Users/91949/Desktop/keys/terraform_key.pub"
}

variable "s3_primary_bucket_arn" {
   description = "primary bucket arn"
   type = string 

}

variable "vpc_launch_template_sg_id" {
   description = "launch template sg id"
   type = string
}