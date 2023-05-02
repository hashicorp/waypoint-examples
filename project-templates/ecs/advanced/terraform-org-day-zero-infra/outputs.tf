output "region" {
  value       = var.region
  description = "region"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "vpc id"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "vpc public subnets"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "vpc private subnets"
}

output "internal_security_group_id" {
  value       = aws_security_group.internal.id
  description = "vpc internal security group id"
}

output "ecs_cluster_name" {
  value       = module.ecs.cluster_name
  description = "ECS cluster name"
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.services.name
  description = "log group name for services running on this cluster"
}