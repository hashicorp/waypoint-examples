variable "cluster_name" {
  description = "Name of aws fargate cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources created by ecs module"
  type        = map(string)
  default = {
    terraform   = "true"
  }
}