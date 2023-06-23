resource "vault_auth_backend" "vault_dev_aws_auth_backend" {
  provider = vault.dev
  type     = "aws"
}

resource "vault_auth_backend" "vault_prod_aws_auth_backend" {
  provider = vault.prod
  type     = "aws"
}

#resource "vault_aws_auth_backend_client" "vault_dev_aws_auth_backend_client_config" {
#  provider = vault.dev
#  backend = "aws"
#  access_key = data.tfe_outputs.org_day_zero_infra.values.vault_aws_auth_method_iam_user_access_key_id
#  secret_key = data.tfe_outputs.org_day_zero_infra.values.vault_aws_auth_method_iam_user_secret_access_key
#}
#
#
#resource "vault_aws_auth_backend_client" "vault_prod_aws_auth_backend_client_config" {
#  provider = vault.prod
#  backend = "aws"
#  access_key = data.tfe_outputs.org_day_zero_infra.values.vault_aws_auth_method_iam_user_access_key_id
#  secret_key = data.tfe_outputs.org_day_zero_infra.values.vault_aws_auth_method_iam_user_secret_access_key
#}

# TODO: Set up auth for TFC to auth to Vault without root token
