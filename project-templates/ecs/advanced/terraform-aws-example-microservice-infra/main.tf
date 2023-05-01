module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"

  cluster_name = var.cluster_name
  tags         = var.tags
}

resource "aws_cloudwatch_log_group" "services" {
  name = "ecs_cluster_${var.cluster_name}"
  tags = var.tags
  retention_in_days = 7
}

resource "aws_iam_openid_connect_provider" "github_aws_oidc_auth_provider" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Grabbed this from: https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

