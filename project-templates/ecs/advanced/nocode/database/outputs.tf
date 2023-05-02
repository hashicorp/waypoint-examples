output "dev_db_secrets_engine_policy_name" {
  value = vault_policy.dev_app_db_policy.name
}

output "prod_db_secrets_engine_policy_name" {
  value = vault_policy.prod_app_db_policy.name
}
