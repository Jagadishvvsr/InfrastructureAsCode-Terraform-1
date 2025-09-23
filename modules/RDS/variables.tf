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

variable "Environment" {
    description = "Environment type"
    type = string
    default = "TEST"
}

variable "private_subnet_ids" {
    description = "Private subnet ids from vpc"
    type = list(string)
}

variable "rds_sg_id" {
    description = "data base SG"
    type = string
}