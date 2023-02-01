# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "tfc_org_name" {
  description = "Name of your desired tfc org. Must be unique."
  type        = string
}

variable "tfc_token" {
  description = "The token used to authenticate with Terraform Cloud."
  type        = string
  sensitive   = true
}

variable "tfc_email" {
  description = "TFC admin email address."
  type        = string
}
