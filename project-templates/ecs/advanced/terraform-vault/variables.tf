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

variable "tfc_organization_name" {
  type = string
  description = "The organization of the day zero infrastructure workspace."
}

variable "day_zero_infra_tfc_workspace_name" {
  type = string
}
