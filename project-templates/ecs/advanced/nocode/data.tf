data "terraform_remote_state" "org_day_zero_infra" {
  backend = "remote"
  config = {
    organization = "hcp_waypoint_integration"
    workspaces = {
      name = "waypoint-templating-advanced-example-day-zero-infra"
    }
  }
}