variable "repo_name" {
  type = string
}

variable "github_org_name" {
  type = string
}

variable "template_repo_name" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}