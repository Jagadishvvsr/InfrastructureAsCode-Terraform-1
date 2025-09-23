    variable "vpc_CIDR_block" {
        description = "VPC CIDR BLOCK"
        type = string
        default = "10.0.0.0/16"
    }

    variable "subnet_config" {
        description = "cidr block for subnets in the vpc"
        type = map(object({
            cidr = string
            az = string
            type = string
        }))
        default = {
            public1a = {cidr = "10.0.0.0/24" , az = "us-east-1a" , type = "public"} 
            public1b = {cidr = "10.0.1.0/24", az = "us-east-1b" , type = "public"}
            private1a = {cidr = "10.0.16.0/20" , az = "us-east-1a" , type = "private"}
            private1b = {cidr = "10.0.32.0/20" , az = "us-east-1b" , type = "private"}
        }
    }


    variable "ingress_port" {
         description = "Ingress port for NACL"
         type = string
         default = "80"
    }

    variable "https_ingress_port" {
     description = "https port number"
     type = string
     default = "80"
   }
   
    variable "rds_ingress_port" {
     description = "rds port number"
     type = string
     default = "3306"
   }
   