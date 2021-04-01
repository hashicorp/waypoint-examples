terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.32.0"
    }
  }

  required_version = "~> 0.14"
}

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "waypoint-lambda" {
  name = "learn-waypoint-lambda"
}