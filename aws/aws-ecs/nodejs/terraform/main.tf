data "aws_vpc" "selected" {
  default = true
}

output "test" {
  value = data.aws_vpc.selected.id
}
