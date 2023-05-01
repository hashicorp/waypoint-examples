resource "hcp_hvn" "hcp_waypoint_testing_hvn" {
  hvn_id         = "hcp-waypoint-testing-hvn"
  cloud_provider = "aws"
  region         = "us-east-2"
}

resource "hcp_vault_cluster" "dev_vault_cluster" {
  cluster_id      = "dev-vault-cluster"
  hvn_id          = hcp_hvn.hcp_waypoint_testing_hvn.hvn_id
  tier            = "standard_large"
  public_endpoint = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "hcp_vault_cluster_admin_token" "dev_vault_cluster_admin_token" {
  cluster_id = hcp_vault_cluster.dev_vault_cluster.cluster_id
}

resource "hcp_vault_cluster" "prod_vault_cluster" {
  cluster_id      = "prod-vault-cluster"
  hvn_id          = hcp_hvn.hcp_waypoint_testing_hvn.hvn_id
  tier            = "standard_large"
  public_endpoint = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "hcp_vault_cluster_admin_token" "prod_vault_cluster_admin_token" {
  cluster_id = hcp_vault_cluster.prod_vault_cluster.cluster_id
}