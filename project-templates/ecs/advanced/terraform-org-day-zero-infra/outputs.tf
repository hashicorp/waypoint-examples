output "region" {
  value       = var.region
  description = "region"
}

output "vpc_id" {
  value = {
    for key, vpc in module.vpc : key => vpc.vpc_id
  }
  description = "vpc id"
}

output "public_subnets" {
  value = {
    for key, vpc in module.vpc : key => vpc.public_subnets
  }
  description = "vpc public subnets"
}

output "private_subnets" {
  value = {
    for key, vpc in module.vpc : key => vpc.private_subnets
  }
  description = "vpc private subnets"
}

output "internal_security_group_id" {
  value = {
    for key, sg in aws_security_group.internal : key => sg.name
  }
  description = "vpc internal security group id"
}

output "ecs_cluster_name" {
  value = {
    for key, ecs in module.ecs : key => ecs.cluster_name
  }
  description = "ECS cluster name"
}

output "log_group_name" {
  value = {
    for key, service in aws_cloudwatch_log_group.services : key => service.name
  }
  description = "log group name for services running on this cluster"
}

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
