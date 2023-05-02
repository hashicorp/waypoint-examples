variable "region" {
  type    = string
  default = "us-east-1"
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