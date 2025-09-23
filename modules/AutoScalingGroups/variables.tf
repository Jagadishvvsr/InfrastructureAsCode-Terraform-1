/*
variable "custom_ami_image" {
   description = "AMI image"
   type = string
} */

variable "launch_template_id" {
   description = "launch template id"
   type = string
   default = ""
}

variable "subnet_private1a" {
   description = "private subnet 1 id"
   type = string
}

variable "subnet_private1b" {
   description = "private subnet 1 id"
   type = string
}

variable "desired_capacity" {
   description = "desired capacity of auto scaoling"
   type = number
   default = 1
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

variable "tags" {
   description = "instance tags"
   type= string
   default = "TEST"
}

variable "tg_blue_arn" {
   description = " blue target group arn"
   type = string
   
}