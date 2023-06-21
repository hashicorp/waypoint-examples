output "vault_dev_aws_auth_method_path" {
  value = vault_auth_backend.vault_dev_aws_auth_backend.path
}

output "vault_prod_aws_auth_method_path" {
  value = vault_auth_backend.vault_prod_aws_auth_backend.path
}