variable "project_name" {
  type        = string
  description = "Name of the Waypoint project"
}

variable "dev_vault_token" {
  sensitive = true
  type      = string
}

variable "prod_vault_token" {
  sensitive = true
  type      = string
}

variable "dev_vault_address" {
  type = string
}

variable "prod_vault_address" {
  type = string
}

variable "aws_account_id" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "The token used to copy a GitHub repo template for the new Waypoint project's repo."
}

variable "github_repo_owner" {
  type        = string
  description = <<EOF
The GitHub owner of the template GitHub repository and the owner of the
repository to be created. This token needs permissions to create, update and
delete repos.
EOF
}

variable "aws_region" {
  default = "us-east-2"
}
