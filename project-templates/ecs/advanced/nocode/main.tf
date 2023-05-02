# Creates the app code repo from a template with CI configured for GitHub
# Actions
module "ci" {
  source = "./ci"
  repo_name = var.project_name
}

# Creates dev and prod DBs, as well as a Vault mount for a database secrets
# engine for just-in-time DB credentials
module "database" {
  source = "./database"
  app_name = var.project_name
}

# Creates dev and prod Vault resources, which will enable Waypoint to auth to
# Vault via IAM to retrieve app secrets
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

# Creates resources for application to run in a dev environment
module "dev" {
  source  = "app.terraform.io/acmecorpinfra/waypoint-ecs/aws"
  version = "0.0.1"

  # App-specific config
  waypoint_project = var.project_name
  application_port = 3000 # TODO(izaak): allow to be configured via input variables. It's pretty draconian to not allow app devs to choose this.

  waypoint_workspace = "dev"

  # Module config
  alb_internal = true
  create_ecr   = false # Prod creates the ecr registry

  # Existing infrastructure
  aws_region       = "us-east-1"
  vpc_id           = data.terraform_remote_state.networking-dev-us-east-1.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.networking-dev-us-east-1.outputs.private_subnets
  private_subnets  = data.terraform_remote_state.networking-dev-us-east-1.outputs.public_subnets
  ecs_cluster_name = data.terraform_remote_state.microservice-infra-dev-us-east-1.outputs.ecs_cluster_name
  log_group_name   = data.terraform_remote_state.microservice-infra-dev-us-east-1.outputs.log_group_name

  tags = {
    env       = "dev"
    corp      = "acmecorp"
    workload  = "microservice"
    project   = var.project_name
  }
}

# Creates resources for application to run in a prod environment
module "prod" {
  source  = "app.terraform.io/acmecorpinfra/waypoint-ecs/aws"
  version = "0.0.1"

  # App-specific config
  waypoint_project = var.project_name
  application_port = 3000 # TODO(izaak): allow to be configured via input variables. It's pretty draconian to not allow app devs to choose this.

  waypoint_workspace = "prod"

  # Module config
  alb_internal = false
  create_ecr   = true

  # Existing infrastructure
  aws_region       = "us-east-1"
  vpc_id           = data.terraform_remote_state.networking-prod-us-east-1.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.networking-prod-us-east-1.outputs.private_subnets
  private_subnets  = data.terraform_remote_state.networking-prod-us-east-1.outputs.public_subnets
  ecs_cluster_name = data.terraform_remote_state.microservice-infra-prod-us-east-1.outputs.ecs_cluster_name
  log_group_name   = data.terraform_remote_state.microservice-infra-prod-us-east-1.outputs.log_group_name

  tags = {
    env       = "prod"
    corp      = "acmecorp"
    workload  = "microservice"
    project   = var.project_name
  }
}
