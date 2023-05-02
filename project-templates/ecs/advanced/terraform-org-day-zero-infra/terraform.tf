terraform {
  cloud {
    workspaces {
      organization = "hcp_waypoint_integration"
      workspace    = "waypoint-templating-advanced-example-microservice-infra"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}

terraform {
  cloud {
    organization = "hcp_waypoint_integration"

    workspaces {
      name = "waypoint-templating-advanced-example-network-infra"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}