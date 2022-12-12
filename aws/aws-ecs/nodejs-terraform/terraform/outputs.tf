# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "ecs cluster name"
}