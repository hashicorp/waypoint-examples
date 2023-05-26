data "tfe_outputs" "org_day_zero_infra" {
  organization = var.tfc_organization_name
  workspace    = var.day_zero_infra_tfc_workspace_name
}