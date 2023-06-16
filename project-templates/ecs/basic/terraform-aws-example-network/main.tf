terraform {
  cloud {
    organization = "{{YOUR_TERRAFORM_ORGANIZATION_NAME}}"
    workspaces {
      name = "aws-example-network"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  cidr = "172.31.0.0/16"

  azs             = ["us-west-1b", "us-west-1c"]
  private_subnets = ["172.31.0.0/20", "172.31.16.0/20"]
  public_subnets  = ["172.31.80.0/20", "172.31.96.0/20"]

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
