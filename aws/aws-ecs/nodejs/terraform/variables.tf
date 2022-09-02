
variable "name" {
  type        = string
  description = "Name for infrastructure resources"
  default     = "tfcwaypoint"
}

# variable "tags" {
#   type        = map(string)
#   description = "Tags to add to infrastructure resources"
#   default     = {}
# }

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
  validation {
    condition     = contains(["us-west-2", "us-west-2"], var.region)
    error_message = "Region must be a valid one for HCP."
  }
}
