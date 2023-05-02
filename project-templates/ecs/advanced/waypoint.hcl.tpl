project = "{{ .ProjectName }}"

app "{{ .ProjectName }}" {
  config {
    # TODO: Include env vars for DB creds
  }

  build {
    # The docker-pull plugin will pull the image from ECR and inject the
    # Waypoint Entrypoint
    use "docker-pull" {
      image = # TODO
      tag   = # TODO
    }

    registry {
      use "aws-ecr" {
        region     = var.tfc_infra.waypoint-ecs.region
        repository = var.tfc_infra.waypoint-ecs.ecr_repository_name
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
    use "aws-ecs" {
      count = 1
      memory = 512
      cpu = 256
      service_port = 3000
      assign_public_ip = false
      logging {
        create_group = false
      }

      cluster             = var.tfc_infra.waypoint-ecs.ecs_cluster_name
      log_group           = var.tfc_infra.waypoint-ecs.log_group_name
      execution_role_name = var.tfc_infra.waypoint-ecs.execution_role_name
      task_role_name      = var.tfc_infra.waypoint-ecs.task_role_name
      region              = var.tfc_infra.waypoint-ecs.region
      subnets             = var.tfc_infra.waypoint-ecs.private_subnets
      security_group_ids  = [var.tfc_infra.waypoint-ecs.security_group_id]
      alb {
        load_balancer_arn = var.tfc_infra.waypoint-ecs.alb_arn
        subnets           = var.tfc_infra.waypoint-ecs.public_subnets
      }
    }

    # TODO: Use workspaces for dev and prod
  }
}

variable "tfc_infra" {
  default = dynamic("terraform-cloud", {
    organization = "{{ .OrgName }}"
    workspace    = "{{ .ProjectName }}"
  })
  type        = any
  sensitive   = false
  description = "all outputs from this app's tfc workspace"
}

variable "database" {
  default = dynamic("vault", {
    # TODO: Add necessary fields for Vault plugin (based on DB secrets engine path)
  })
}