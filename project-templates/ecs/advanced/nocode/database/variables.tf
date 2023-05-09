variable "app_name" {
  type = string
}

variable "dev_db_subnets" {
  type = list(string)
}

variable "prod_db_subnets" {
  type = list(string)
}

variable "dev_vpc_id" {
  type = string
}

variable "prod_vpc_id" {
  type = string
}

variable "vault_cidr" {
  type = string
}