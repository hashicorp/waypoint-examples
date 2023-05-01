variable "project_name" {
  type = string
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
  type = string
  sensitive = true
}