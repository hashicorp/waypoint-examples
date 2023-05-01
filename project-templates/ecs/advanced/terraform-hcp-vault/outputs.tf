output "dev_vault_url" {
  value = hcp_vault_cluster.dev_vault_cluster.vault_public_endpoint_url
}

output "dev_vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.dev_vault_cluster_admin_token.token
  sensitive = true
}

output "prod_vault_url" {
  value = hcp_vault_cluster.prod_vault_cluster.vault_public_endpoint_url
}

output "prod_vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.prod_vault_cluster_admin_token.token
  sensitive = true
}
