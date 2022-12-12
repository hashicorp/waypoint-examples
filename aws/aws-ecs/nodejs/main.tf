# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-04e229bcb91f0f16b" # Nginx
  instance_type = "t2.medium"
  count         = 1

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "Geoffrey"
  }
}


resource "aws_security_group" "default" {
  name_prefix = "Geoffrey"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Created-by" = "Geoffrey"

  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}