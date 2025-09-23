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
  alias = "primary"
  profile = "devops-user"
  region = "us-east-1"
}

provider "aws" {
  alias = "replica"
  region = "eu-central-1"
}