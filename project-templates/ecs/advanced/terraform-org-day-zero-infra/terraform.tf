terraform {
  cloud {
    organization = "hcp_waypoint_integration"

    workspaces {
      name = "waypoint-templating-advanced-example-day-zero-infra"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }

    datadog = {
      source = "datadog/datadog"
    }

    # TODO: Update this to use the officially published provider when
    # multi-org/project is supported
    hcp = {
      source  = "localhost/providers/hcp"
      version = "0.0.1"
    }
  }
}
