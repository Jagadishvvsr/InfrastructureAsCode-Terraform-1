data "aws_ami" "amazonlinuxami" {
most_recent = true
owners = ["amazon"]

filter {
name = "name"
values = ["amzn2-ami-hvm-*-x86_64-gp2"]
}
}


resource "aws_iam_role" "bastion_role" {
  name = "${var.environment}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.environment}-bastion-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.environment}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazonlinuxami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.Bastionkey.key_name
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.bastionhost_sg]
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name


  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-ssm-agent
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              
              # Security hardening
              sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
              sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
              systemctl restart sshd
              
              # Set up log forwarding
              yum install -y awslogs
              systemctl enable awslogsd
              systemctl start awslogsd

              EOF

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "${var.environment}-bastion-host"
  }
}

resource "aws_key_pair" "Bastionkey" {
  key_name   = "Bastion-key"
  public_key = file(var.bastion_key)
}