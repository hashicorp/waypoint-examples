resource "vault_auth_backend" "vault_dev_aws_auth_backend" {
  provider = vault.dev
  type     = "aws"
}

resource "vault_auth_backend" "vault_prod_aws_auth_backend" {
  provider = vault.prod
  type     = "aws"
}

# TODO: Set up auth for TFC to auth to Vault without root token
