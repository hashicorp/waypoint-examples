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
