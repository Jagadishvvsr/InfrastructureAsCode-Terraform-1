output "vpc_id" {
  description = "The ID of the main VPC"
  value       = aws_vpc.main.id
}

output "elastic_ip_id" {
  description = "The ID of the Elastic IP used for NAT"
  value       = aws_eip.my_eip.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.my_nat.id
}

output "subnet_details" {
  description = "Map of subnet names to their ID, CIDR, and available IPs"
  value = {
    for name, subnet in aws_subnet.subnets_vpc :
    name => {
      id            = subnet.id
      cidr_block    = subnet.cidr_block
      available_ips = pow(2, 32 - tonumber(split("/", subnet.cidr_block)[1])) - 5
    }
  }
}

output "launch_template_sg_id" {
  description = "Security Group ID for the launch template / EC2 instances"
  value       = aws_security_group.launch_template_sg.id
}

output "load_balancer_sg_id" {
  description = "Security Group ID for the load balancer"
  value       = aws_security_group.load_balancer_sg.id
}

output "rds_sg_id" {
  description = "Security Group ID for the RDS database"
  value       = aws_security_group.rds_sg.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs for databases"
  value = [
    for name, subnet in aws_subnet.subnets_vpc :
    subnet.id if var.subnet_config[name].type == "private"
  ]
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    for name, subnet in aws_subnet.subnets_vpc:
    subnet.id if var.subnet_config[name].type == "public"
  ]
}

output "bastionhost_sg_id" {
  description = "Bastion host security group ID"
  value = aws_security_group.bastionhost_sg.id
}