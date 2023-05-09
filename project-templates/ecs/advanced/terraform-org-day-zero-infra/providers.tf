provider "aws" {
  region = var.region
}

provider "datadog" {
  # DD_API_KEY env var
  validate = false
}

provider "hcp" {
  project_id = var.hcp_project_id
}

provider "tfe" {}