variable "project_name" {
  type        = string
  description = "Name of the Waypoint project"
}

variable "dev_vault_token" {
  sensitive = true
  type      = string
}

variable "prod_vault_token" {
  sensitive = true
  type      = string
}

variable "dev_vault_address" {
  type = string
}

variable "prod_vault_address" {
  type = string
}

variable "aws_account_id" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "The token used to copy a GitHub repo template for the new Waypoint project's repo."
}

variable "aws_region" {
  default = "us-east-2"
}