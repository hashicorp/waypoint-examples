output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "ecs cluster name"
}