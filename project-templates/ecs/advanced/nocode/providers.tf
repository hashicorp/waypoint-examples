provider "aws" {
  # Set env vars
}

provider "github" {
  # Set "GITHUB_TOKEN" env var
}

provider "datadog" {
  # Set "DD_API_KEY" env var
}

provider "vault" {
  alias   = "dev"
  token   = var.dev_vault_token
  address = var.dev_vault_address
}

provider "vault" {
  alias   = "prod"
  token   = var.prod_vault_token
  address = var.prod_vault_address
}