# Terraform block
terraform {
  required_version = "~> 1.10" # alows 1.10.xx and deny 1.11.xx

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "myportfolio"

  vpc_cidr = "10.10.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]

  tags = {
    Owner     = "Gabriel"
    Project   = "MyPortfolio"
    ManagedBy = "Terraform"
  }
}
