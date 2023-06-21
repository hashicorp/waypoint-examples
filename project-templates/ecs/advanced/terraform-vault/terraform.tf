terraform {
  cloud {
    organization = "{{YOUR_TERRAFORM_ORGANIZATION_NAME}}"
    workspaces {
      name = "terraform-vault"
    }
  }
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
  }
}