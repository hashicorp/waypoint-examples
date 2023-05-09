terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  cidr = "172.31.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  private_subnets = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20", "172.31.48.0/20", "172.31.64.0/20"]
  public_subnets  = ["172.31.80.0/20", "172.31.96.0/20", "172.31.112.0/20", "172.31.128.0/20", "172.31.144.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.tags
}

resource "aws_security_group" "internal" {
  name        = "internal"
  description = "Allow all internal traffic"
  vpc_id      = module.vpc.vpc_id

  # Allow egress to anything
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow ingress from other internal microservice_infra
  ingress {
    description      = "internal traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  tags = var.tags
}
