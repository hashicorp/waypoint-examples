### Networking resources ###
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  cidr = "172.31.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  private_subnets = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20", "172.31.48.0/20", "172.31.64.0/20"]
  public_subnets  = ["172.31.80.0/20", "172.31.96.0/20", "172.31.112.0/20", "172.31.128.0/20", "172.31.144.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.vpc_tags
}

resource "aws_security_group" "internal" {
  name        = "internal"
  description = "Allow all internal traffic"
  vpc_id      = module.vpc.vpc_id

  # Allow egress to anything
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow ingress from other internal microservice_infra
  ingress {
    description = "internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  tags = var.vpc_tags
}


### Microservice resources ###
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"

  cluster_name = var.cluster_name
  tags         = var.ecs_tags
}

resource "aws_cloudwatch_log_group" "services" {
  name              = "ecs_cluster_${var.cluster_name}"
  tags              = var.ecs_tags
  retention_in_days = 7
}

resource "aws_iam_openid_connect_provider" "github_aws_oidc_auth_provider" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Grabbed this from: https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

### Telemetry resources ###
# https://docs.datadoghq.com/integrations/guide/aws-terraform-setup/
# TODO: Check telegraf and/or prometheus exporter
# TODO: Move to day 0 code
resource "datadog_integration_aws" "aws_integration" {
  account_id = var.aws_account_id
  role_name  = "DatadogAWSIntegrationRole"
}
