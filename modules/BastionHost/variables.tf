variable "environment" {
    description = "environment"
    type = string
}

variable "instance_type" {
    description = "Instancve type"
    type = string
    default = "t2.micro"
}

variable "bastion_key" {
  description = "Bastion host public key"
  type = string
  default = "C:/Users/91949/Desktop/keys/terraform_key.pub"

}

variable "bastionhost_sg" {
    description = "Bastion host security group"
    type = string
}

variable "public_subnet_ids" {
    description = "This is public subnet ID"
    type = list(string)
}
