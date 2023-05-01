# Creates the repo with CI
module "ci" {
  source = "./ci"
  repo_name = var.project_name
}

# Creates dev and prod DBs
module "database" {
  source = "./database"
  app_name = var.project_name
}

# Creates dev and prod Vault resources
module "secrets" {
  source = "./secrets"
  app_name = var.project_name
  dev_db_secrets_engine_path = module.database.dev_database_secrets_engine_path
  prod_db_secrets_engine_path = module.database.prod_database_secrets_engine_path
}

# Creates dashboards and alerts
module "telemetry" {
  source = "./telemetry"
  app_name = var.project_name
  aws_account_id = var.aws_account_id
}
