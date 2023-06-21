# terraform-org-day-zero-infra

This Terraform module creates resources using several providers to establish
the foundation of the solution architecture for an organization. This includes:

- AWS VPC
- AWS ECS cluster
- DataDog integration with AWS
- HCP Vault clusters

Environment variables required for authentication:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- DD_API_KEY
- HCP_CLIENT_ID
- HCP_CLIENT_SECRET