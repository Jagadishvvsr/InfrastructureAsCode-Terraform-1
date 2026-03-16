# Monolithic Terraform AWS Infrastructure

This repository demonstrates a robust, production-ready AWS infrastructure for a monolithic application, showcasing IaC best practices, modularity, and secure cloud architecture.

# 🚀🚀 What This Repo Shows

End-to-end infrastructure as code (Terraform) for multi-environment deployments (dev/test/prod)

Network design mastery: VPC with private/public subnets, NAT, route tables, and security groups

Database security & automation: Multi-AZ PostgreSQL RDS, encrypted storage, IAM authentication, and Secrets Manager integration for credentials

Highly available application layer: ALB with health checks, multi-target group setup, and CloudFront CDN for global reach

Application protection: CloudFront + WAF to defend against OWASP top 10 threats

Secure operational access: Bastion host with SSM, hardened SSH, and IAM roles

Modular, reusable architecture: Code is split into modules, enabling easy replication and environment isolation

# 🗂🗂 Modules Structure

Modules are organized to enforce reusability and clean separation of concerns:

Module	Purpose
vpc/	VPC, public/private subnets, NAT, routing, security groups
rds/	PostgreSQL RDS, DB subnet group, IAM auth, Secrets Manager
launch-template/	EC2 launch templates, custom AMI integration
alb/	Application Load Balancer, target groups, listeners
cloudfront/	CloudFront distribution, caching policies, WAF
bastion/	Bastion host with IAM role & SSM for secure access

# 🌐🌐 Architecture Highlights

Private subnets host sensitive services (DB), isolated from public internet

ALB only allows CloudFront connections, ensuring origin security

CloudFront + WAF layer for global content distribution and application firewall protection

Secrets Manager centralizes sensitive credentials, avoiding hardcoding or env-variable leaks

IAM roles & instance profiles enforce least-privilege security on EC2 and Bastion hosts

# ⚡⚡ Key Features

Multi-environment deployments via dev/, test/, prod/ root folders

Custom AMI builds for EC2 instances, integrated seamlessly via Terraform

Full observability: CloudWatch logs forwarding for Bastion and app layers

Highly available RDS: Multi-AZ, encrypted, IAM-authenticated, with automated backups

Secure connectivity: Bastion host with SSM, hardened SSH, private subnet DB access only

# 🛠🛠 Usage

x

terraform init


Plan for specific environment

terraform plan -var-file="dev.tfvars" -out=tfplan


# Apply infrastructure

terraform apply tfplan


# Destroy when needed

terraform destroy -var-file="dev.tfvars"

# 🔑🔑 Outputs

Typical Terraform outputs to reference in your app:

VPC ID

Subnet IDs (public & private)

RDS Endpoint & URL

Bastion Host Public IP

ALB DNS Name

CloudFront Distribution URL

# 📌📌 Notes

Secure by design: all secrets in AWS Secrets Manager

ALB only accessible through CloudFront, enforced via security groups

WAF integrated for layer 7 protection

Modular Terraform code ensures repeatable deployments and environment isolation

# 📄 License

This repository is licensed under Creative Commons Zero (CC0 1.0 Universal).
You are free to view, learn from, or share this code for portfolio and recruitment purposes.

Please reference below the archiecture diagram..

<img width="1305" height="686" alt="image" src="https://github.com/user-attachments/assets/802f413f-ab1f-4978-b458-3093f8fd6af4" />
