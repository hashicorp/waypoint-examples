variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    terraform   = "true"
  }
}