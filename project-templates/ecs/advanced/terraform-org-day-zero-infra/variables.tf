variable "environments" {
  type = set(string)
  default = [
    "dev",
    "prod"
  ]
}

variable "availability_zones" {
  type = list(string)
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
}

variable "cidr" {
  type = map(string)
  default = {
    dev  = "172.31.0.0/16"
    prod = "172.30.0.0/16"
  }
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "cluster_name" {
  description = "Name of aws fargate cluster"
  type        = string
}

variable "ecs_tags" {
  description = "Tags to apply to resources created by ecs module"
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "aws_account_id" {
  type      = string
  sensitive = true
}

variable "hcp_client_id" {
  type      = string
  sensitive = true
}

variable "hcp_client_secret" {
  type      = string
  sensitive = true
}

variable "hcp_project_id" {
  type = string
}

variable "datadog_api_key" {
  type = string
  sensitive = true
}

variable "datadog_app_key" {
  type = string
  sensitive = true
}
