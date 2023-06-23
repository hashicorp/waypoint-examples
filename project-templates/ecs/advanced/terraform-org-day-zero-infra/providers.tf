provider "aws" {
  region = var.region
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

provider "hcp" {
  client_id = var.hcp_client_id
  client_secret = var.hcp_client_secret
  project_id = var.hcp_project_id
}

provider "tfe" {}