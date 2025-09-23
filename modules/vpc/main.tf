resource "aws_vpc" "main" {
  cidr_block = var.vpc_CIDR_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "subnets_vpc" {
  for_each = var.subnet_config

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    Name = each.key
    Type = each.value.type
  }

}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "my_routetable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = { Name = "my_routetable" }
}

resource "aws_route_table_association" "public_route" {
  for_each = {for k, v in aws_subnet.subnets_vpc : k => v if var.subnet_config[k].type == "public"}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_routetable.id
}


resource "aws_eip" "my_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.subnets_vpc["public1a"].id

  tags = {
    Name = "gw_NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my_igw]
}

#resource "aws_nat_gateway_eip_association" "my_eip" {
#  allocation_id  = aws_eip.my_eip.id
#  nat_gateway_id = aws_nat_gateway.my_nat.id
#}

resource "aws_route_table" "my_private_routetable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }

  tags = { Name = "my_routetable" }
}

resource "aws_route_table_association" "private_route" {
  for_each = { for k , v in aws_subnet.subnets_vpc : k => v if var.subnet_config[k].type == "private"}
  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_private_routetable.id
}


resource "aws_network_acl" "main_nacl" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = var.ingress_port
    to_port    = var.ingress_port
  }

  tags = {
    Name = "main_nacl"
  }
}

resource "aws_network_acl_association" "my_main_nacl_asc" {
  for_each = aws_subnet.subnets_vpc

  network_acl_id = aws_network_acl.main_nacl.id
  subnet_id      = each.value.id
}



resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  
  tags = {
    Environment = "Test"
  }
}

resource "aws_vpc_endpoint_route_table_association" "main_vpc_route-endpoint" {
  route_table_id  = aws_route_table.my_private_routetable.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}



resource "aws_security_group" "launch_template_sg" {
   name = "launch_template_sg"
   vpc_id = aws_vpc.main.id
   description = "allow only traffic from load balancer and ssh from bastion host"

  ingress {
  from_port       = var.https_ingress_port
  to_port         = var.https_ingress_port
  protocol        = "tcp"
  security_groups = [aws_security_group.load_balancer_sg.id]  # traffic from LB only
}

ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.bastionhost_sg.id]  # SSH from bastion only
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_ip_ranges" "cloudfront" {
  services = ["CLOUDFRONT"]
  regions  = ["GLOBAL"]
}


resource "aws_security_group" "load_balancer_sg" {
   name = "load_balancer_sg"
   vpc_id = aws_vpc.main.id
   description = "allow only traffic from cloud front"
    
  dynamic "ingress" {
    for_each = data.aws_ip_ranges.cloudfront.cidr_blocks
    content {
      from_port = var.https_ingress_port
      to_port = var.https_ingress_port
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "bastionhost_sg" {
  # ... other configuration ...

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  # ... other configuration ...

  ingress {
    from_port        = var.rds_ingress_port
    to_port          = var.rds_ingress_port
    protocol         = "tcp"
    security_groups = [aws_security_group.launch_template_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "vpc_flow_log_groupe"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_logs_role" {
  name               = "flow_logs_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "flow_logs_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "flow_logs_role_policy" {
  name   = "low_logs_role_policy"
  role   = aws_iam_role.flow_logs_role.id
  policy = data.aws_iam_policy_document.flow_logs_policy.json
} 