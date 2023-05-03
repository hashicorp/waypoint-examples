terraform {
  cloud {
    organization = "hcp_waypoint_integration"
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