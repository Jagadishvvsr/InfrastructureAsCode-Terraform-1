terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "devops-user"
  region = "us-east-1"
}