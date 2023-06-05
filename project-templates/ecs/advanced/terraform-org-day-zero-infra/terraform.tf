terraform {
  cloud {
    organization = "{{YOUR_TERRAFORM_ORGANIZATION_NAME}}"

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
  }
}
