
# IAM role EC2 will assume
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM policy to allow S3 access (scoped to your bucket)
resource "aws_iam_policy" "s3_access" {
  name = "ec2-s3-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
         Resource = [
          var.s3_primary_bucket_arn,
          "${var.s3_primary_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_role.name
}






# launch template configuration

data "aws_ami" "custom_packer_ami_image" {
  count       = var.custom_ami_image == "" ? 1 : 0
  most_recent = true
  owners      = ["891612582498"] # your AWS account ID (where packer built the AMI)

  filter {
    name   = "name"
    values = ["packer_AWS_ubuntu_custom_AMI_*"]
  }
}

locals {
  custom_ami = var.custom_ami_image != "" ? var.custom_ami_image : data.aws_ami.custom_packer_ami_image[0].id
}



resource "aws_launch_template" "custom_launch_template" {
  name_prefix   = "custom-launch-template-"
  image_id      = local.custom_ami
  instance_type = var.launch_instance_type
  key_name      = aws_key_pair.deployer.key_name
  

    block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

   vpc_security_group_ids = [var.vpc_launch_template_sg_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "custom-template"
    }
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.pub_key
}