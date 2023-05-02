provider "aws" {
  region = var.region
}

provider "datadog" {
  # DD_API_KEY env var
}