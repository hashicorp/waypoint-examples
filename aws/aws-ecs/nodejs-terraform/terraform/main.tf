data "aws_vpc" "selected" {
  default = true
}

output "test" {
  value = data.aws_vpc.selected.id
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.29"
    }
  }
}