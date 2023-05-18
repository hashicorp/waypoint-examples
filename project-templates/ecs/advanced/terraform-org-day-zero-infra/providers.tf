provider "aws" {
  region = var.region
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

provider "hcp" {
  project_id = var.hcp_project_id
}

provider "tfe" {}