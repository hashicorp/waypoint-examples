### Networking resources ###
module "vpc" {
  for_each = var.environments

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "${var.vpc_name}-${each.key}"

  # should dev and prod have the same CIDR block?
  cidr = var.cidr[each.key]

  azs                        = var.availability_zones
  private_subnets            = [for k, v in var.availability_zones : cidrsubnet(var.cidr[each.key], 8, k)]
  public_subnets             = [for k, v in var.availability_zones : cidrsubnet(var.cidr[each.key], 8, k + 4)]
  database_subnet_group_name = "${each.key}-db"
  database_subnets           = [for k, v in var.availability_zones : cidrsubnet(var.cidr[each.key], 8, k + 8)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.vpc_tags
}

resource "aws_route" "dev_hcp_hvn_route" {
  route_table_id            = module.vpc["dev"].private_route_table_ids[0]
  destination_cidr_block    = hcp_hvn.hcp_waypoint_testing_hvn.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.dev_peer.id
}

resource "aws_route" "prod_hcp_hvn_route" {
  route_table_id            = module.vpc["prod"].private_route_table_ids[0]
  destination_cidr_block    = hcp_hvn.hcp_waypoint_testing_hvn.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.prod_peer.id
}

resource "aws_security_group" "internal" {
  for_each = module.vpc

  name        = "internal"
  description = "Allow all internal traffic"
  vpc_id      = each.value.vpc_id

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
  for_each = var.environments

  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"

  cluster_name = "${var.cluster_name}-${each.key}"
  tags         = var.ecs_tags
}

resource "aws_cloudwatch_log_group" "services" {
  for_each = module.ecs

  name              = "ecs_cluster_${each.value.cluster_name}"
  tags              = var.ecs_tags
  retention_in_days = 7
}

// Create the IAM policy in the No Code module, conditions limiting it to the app
// also the OIDC provider role

// https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws
resource "aws_iam_openid_connect_provider" "github_aws_oidc_auth_provider" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Grabbed this from: https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

}

### Telemetry resources ###
# https://docs.datadoghq.com/integrations/guide/aws-terraform-setup/
# TODO: Check telegraf and/or prometheus exporter
resource "datadog_integration_aws" "aws_integration" {
  account_id = var.aws_account_id
  role_name  = "DatadogAWSIntegrationRole"
}

data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      # The account number here is the DataDog account, which needs permission to assume a role
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "${datadog_integration_aws.datadog_integration.external_id}"
      ]
    }
  }
}

data "aws_iam_policy_document" "datadog_aws_integration" {
  statement {
    // Required permissions documented here: https://docs.datadoghq.com/integrations/amazon_web_services/?tab=manual#aws-iam-permissions
    actions = [
      "apigateway:GET",
      "autoscaling:Describe*",
      "backup:List*",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
      "es:ListTags",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomains",
      "events:CreateEventBus",
      "fsx:DescribeFileSystems",
      "fsx:ListTagsForResource",
      "health:DescribeEvents",
      "health:DescribeEventDetails",
      "health:DescribeAffectedEntities",
      "kinesis:List*",
      "kinesis:Describe*",
      "lambda:GetPolicy",
      "lambda:List*",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DescribeSubscriptionFilters",
      "logs:FilterLogEvents",
      "logs:PutSubscriptionFilter",
      "logs:TestMetricFilter",
      "organizations:Describe*",
      "organizations:List*",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "s3:GetBucketLogging",
      "s3:GetBucketLocation",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "ses:Get*",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "states:ListStateMachines",
      "states:DescribeStateMachine",
      "support:DescribeTrustedAdvisor*",
      "support:RefreshTrustedAdvisorCheck",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "datadog_aws_integration" {
  name   = "DatadogAWSIntegrationPolicy"
  policy = data.aws_iam_policy_document.datadog_aws_integration.json
}

resource "aws_iam_role" "datadog_aws_integration" {
  name               = "DatadogAWSIntegrationRole"
  description        = "Role for Datadog AWS Integration"
  assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
}

resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = aws_iam_policy.datadog_aws_integration.arn
}

resource "datadog_integration_aws" "datadog_integration" {
  account_id = var.aws_account_id
  role_name  = "DatadogAWSIntegrationRole"
}

### Secrets Resources ###
resource "hcp_hvn" "hcp_waypoint_testing_hvn" {
  hvn_id         = "hcp-waypoint-testing-hvn"
  cloud_provider = "aws"
  region         = "us-east-2"
}

resource "aws_security_group" "hcp_vault_sg" {
  for_each = var.environments
  name     = "${each.value}-hcp-vault"
  vpc_id   = module.vpc[each.value].vpc_id

  egress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "TCP"
    cidr_blocks = [hcp_hvn.hcp_waypoint_testing_hvn.cidr_block]
  }
}

# TODO: Use for_each for peering resources
resource "hcp_aws_network_peering" "dev_vpc_peering" {
  hvn_id          = hcp_hvn.hcp_waypoint_testing_hvn.hvn_id
  peer_account_id = module.vpc["dev"].vpc_owner_id
  peer_vpc_id     = module.vpc["dev"].vpc_id
  peer_vpc_region = var.region
  peering_id      = "dev-vault-vpc-peering"
}

resource "aws_vpc_peering_connection_accepter" "dev_peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.dev_vpc_peering.provider_peering_id
  auto_accept               = true
}

resource "hcp_hvn_route" "dev_vault_peering_route" {
  hvn_link         = hcp_hvn.hcp_waypoint_testing_hvn.self_link
  hvn_route_id     = "dev-vault-peering-route"
  destination_cidr = module.vpc["dev"].vpc_cidr_block
  target_link      = hcp_aws_network_peering.dev_vpc_peering.self_link
}

resource "hcp_aws_network_peering" "prod_vpc_peering" {
  hvn_id          = hcp_hvn.hcp_waypoint_testing_hvn.hvn_id
  peer_account_id = module.vpc["prod"].vpc_owner_id
  peer_vpc_id     = module.vpc["prod"].vpc_id
  peer_vpc_region = var.region
  peering_id      = "prod-vault-vpc-peering"
}

resource "aws_vpc_peering_connection_accepter" "prod_peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.prod_vpc_peering.provider_peering_id
  auto_accept               = true
}

resource "hcp_hvn_route" "prod_vault_peering_route" {
  hvn_link         = hcp_hvn.hcp_waypoint_testing_hvn.self_link
  hvn_route_id     = "prod-vault-peering-route"
  destination_cidr = module.vpc["prod"].vpc_cidr_block
  target_link      = hcp_aws_network_peering.prod_vpc_peering.self_link
}

resource "hcp_vault_cluster" "dev_vault_cluster" {
  cluster_id      = "dev-vault-cluster"
  hvn_id          = hcp_hvn.hcp_waypoint_testing_hvn.hvn_id
  tier            = "standard_large"
  public_endpoint = true
}

# NOTE: Expires after 6 hours
resource "hcp_vault_cluster_admin_token" "dev_vault_cluster_admin_token" {
  cluster_id = hcp_vault_cluster.dev_vault_cluster.cluster_id
}

resource "hcp_vault_cluster" "prod_vault_cluster" {
  cluster_id      = "prod-vault-cluster"
  hvn_id          = hcp_hvn.hcp_waypoint_testing_hvn.hvn_id
  tier            = "standard_large"
  public_endpoint = true
}

# NOTE: Expires after 6 hours
resource "hcp_vault_cluster_admin_token" "prod_vault_cluster_admin_token" {
  cluster_id = hcp_vault_cluster.prod_vault_cluster.cluster_id
}

# The configuration below is required for the AWS auth method in Vault
data "aws_iam_policy_document" "vault_auth_method_policy_document" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:ListRoles",
      "iam:GetRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vault_auth_method_policy" {
  name   = "vault-aws-auth-method-policy"
  policy = data.aws_iam_policy_document.vault_auth_method_policy_document.json
}
