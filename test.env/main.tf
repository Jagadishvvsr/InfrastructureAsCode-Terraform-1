module "vpc" {
    source = "../modules/vpc"

}


module "BastionHost" {
    source = "../modules/BastionHost"
    environment = var.environment
    instance_type = var.instance_type
    bastionhost_sg = module.vpc.bastionhost_sg_id
    public_subnet_ids = module.vpc.public_subnet_ids
}

module "launch_template" {
  source = "../modules/launch-template"
  custom_ami_image   = var.custom_ami_image
  s3_primary_bucket_arn = module.S3.primary_bucket_arn
  vpc_launch_template_sg_id = module.vpc.launch_template_sg_id
  launch_instance_type = var.launch_instance_type
  pub_key = var.pub_key

  
}

module "ASG" {
    source = "../modules/AutoScalingGroups"
    tg_blue_arn =   module.LoadBalancer.tg_blue_arn
    subnet_private1a = module.vpc.private_subnet_ids[0]
    subnet_private1b = module.vpc.private_subnet_ids[1]
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    launch_template_id = module.launch_template.launch_template_id
    tags = var.tags
}

module "LoadBalancer" {
    source = "../modules/LoadBalancer"
    vpc_public_subnets = module.vpc.private_subnet_ids
    load_balancer_sg_id = module.vpc.load_balancer_sg_id
    vpc_id = module.vpc.vpc_id
    Environment = var.environment
    protocol = var.protocol
    protocol_port = var.protocol_port
    weight_blue = var.weight_blue
    weight_green = var.weight_green
}

module "RDS" {
    source = "../modules/RDS"
    private_subnet_ids = module.vpc.private_subnet_ids
    rds_sg_id = module.vpc.rds_sg_id
    db_instance_class = var.db_instance_class
    Storage_allocation = var.Storage_allocation
    AZ_availability = var.AZ_availability
    storage_type = var.storage_type
    Environment = var.environment


}

module "S3" {
    source = "../modules/S3"

}

module "CloudFront" {
    source = "../modules/CloudFront"
    environment = var.environment
    alb_dns_name = module.LoadBalancer.alb_dns_name
    alb_id = module.LoadBalancer.alb_id
    waf_arn = module.WAF.web_acl_arn
    api_path_pattern = var.api_path_pattern
    static_path_pattern = var.static_path_pattern
    default_ttl = var.default_ttl
    max_ttl = var.max_ttl
    min_ttl = var.min_ttl



}

module "WAF" {
    source = "../modules/WAF"

}





