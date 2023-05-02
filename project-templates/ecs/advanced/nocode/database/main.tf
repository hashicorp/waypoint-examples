module "dev_database" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.app_name}-dev-database"
}

module "prod_database" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.app_name}-prod-database"
}

resource "vault_database_secrets_mount" "dev_database_secrets_engine" {
  provider = vault.dev
  path = "${var.app_name}-database"

  postgresql {
    name              = "${var.app_name}-database"
    connection_url    = module.dev_database.db_instance_address
    verify_connection = true
    username          = module.dev_database.db_instance_username
    password          = module.dev_database.db_instance_password
  }
}

resource "vault_database_secret_backend_role" "dev_app_role" {
  backend             = vault_database_secrets_mount.dev_database_secrets_engine.path
  creation_statements = [] // TODO
  db_name             = module.dev_database.db_instance_name
  name                = "${var.app_name}-role"
}

resource "vault_database_secrets_mount" "prod_database_secrets_engine" {
  provider = vault.prod
  path = "${var.app_name}-database"
  type = "database"

  postgresql {
    name              = "${var.app_name}-database"
    connection_url    = module.prod_database.db_instance_address
    verify_connection = true
    username          = module.prod_database.db_instance_username
    password          = module.prod_database.db_instance_password
  }
}

resource "vault_database_secret_backend_role" "prod_app_role" {
  backend             = vault_database_secrets_mount.prod_database_secrets_engine.path
  creation_statements = [] // TODO
  db_name             = module.dev_database.db_instance_name
  name                = "${var.app_name}-role"
}

resource "vault_policy" "dev_app_db_policy" {
  provider = vault.dev
  name = "${var.app_name}-db-policy"
  policy = <<EOF
path "${vault_database_secrets_mount.dev_database_secrets_engine.path}/${vault_database_secret_backend_role.dev_app_role.name}" {
  capabilities = [ "read", "create" ]
}
EOF
}

resource "vault_policy" "prod_app_db_policy" {
  provider = vault.prod
  name = "${var.app_name}-db-policy"
  policy = <<EOF
path "${vault_database_secrets_mount.prod_database_secrets_engine.path}/${vault_database_secret_backend_role.prod_app_role.name}" {
  capabilities = [ "read", "create" ]
}
EOF
}
