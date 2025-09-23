output "Instance_id" {
    description = "bastion host instance id"
    value = aws_instance.bastion.id
}

output "BastionHost_public_IP" {
    description = "Bastion host public IP"
    value = aws_instance.bastion.public_ip
}