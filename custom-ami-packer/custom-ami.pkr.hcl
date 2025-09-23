packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


data "amazon-ami" "base-ami" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}


source "amazon-ebs" "custom-ubuntu-ami-builder" {
  region                  = var.region
  source_ami              = data.amazon-ami.base-ami.id
  instance_type           = var.instance_type
  ssh_username            = "ubuntu"
  ami_name                = "packer_AWS_ubuntu_custom_AMI_{{timestamp}}"
  #shared_credentials_file = var.credentials_file
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}

build {
  name    = "mycustom-ami-build"
  sources = ["amazon-ebs.custom-ubuntu-ami-builder"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y" ,
      "sudo lsb_release -a",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-get install apache2 apache2-bin -y ",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo apt-get install -y openjdk-17-jdk" ,
    ]
  }
  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
    custom_data = {
      my_custom_data = "custom-ami-data"
    }
  }
}


