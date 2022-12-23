terraform {
  required_providers {
    tfe = {
      version = "~> 0.40.0"
    }
  }
}

provider "tfe" {
  token    = var.tfc_token
}

resource "tfe_organization" "tfe_organization" {
  name = var.tfc_org_name
  email = var.tfc_email
}

resource "tfe_workspace" "waypoint_tfc_vars_example" {
  name         = "waypoint_tfc_vars_example"
  organization = tfe_organization.tfe_organization.name
}