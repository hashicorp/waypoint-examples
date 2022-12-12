# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Using a single workspace:
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "hc-waypoint"

    workspaces {
      name = "hashiconf-demo"
    }
  }
}

provider "aws" {
  region = var.region
  # default_tags {
  #   tags = local.tags
  # }
}
