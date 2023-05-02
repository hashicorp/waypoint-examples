variable "app_name" {
  type = string
}

variable "aws_account_id" {
  type = string
  description = "ID of the account with which DataDog will integrate to retrieve metrics."
}