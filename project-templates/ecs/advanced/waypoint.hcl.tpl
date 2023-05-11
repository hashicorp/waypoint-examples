project = "{{ .ProjectName }}"

app "{{ .ProjectName }}" {
  config {
    env = {
      "DATABASE_USERNAME" = dynamic("vault", {
        path = "{{ .ProjectName }}-database/creds/{{ .ProjectName }}-role"
        key = "username"
      })

      "DATABASE_PASSWORD" = dynamic("vault", {
        path = "{{ .ProjectName }}-database/creds/{{ .ProjectName }}-role"
        key = "password"
      })
    }
  }

  build {
    # The docker-pull plugin will pull the image from ECR and inject the
    # Waypoint Entrypoint
    use "docker-pull" {
      image = var.tfc_infra.prod.ecr_repository_name
      tag   = gitrefpretty()
    }

    registry {
      use "aws-ecr" {
        region     = var.tfc_infra.prod.region
        repository = var.tfc_infra.prod.ecr_repository_name
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
    # By default, use the AWS ECS plugin to deploy to the dev environment
    use "aws-ecs" {
      count = 1
      memory = 512
      cpu = 256
      service_port = 3000
      assign_public_ip = false
      logging {
        create_group = false
      }

      cluster             = var.tfc_infra.dev.ecs_cluster_name
      log_group           = var.tfc_infra.dev.log_group_name
      execution_role_name = var.tfc_infra.dev.execution_role_name
      task_role_name      = var.tfc_infra.dev.task_role_name
      region              = var.tfc_infra.dev.region
      subnets             = var.tfc_infra.dev.private_subnets
      security_group_ids  = [var.tfc_infra.dev.security_group_id]
      alb {
        load_balancer_arn = var.tfc_infra.dev.alb_arn
        subnets           = var.tfc_infra.dev.public_subnets
      }
    }

    workspace "prod" {
      use "aws-ecs" {
        count = 1
        memory = 512
        cpu = 256
        service_port = 3000
        assign_public_ip = false
        logging {
          create_group = false
        }

        cluster             = var.tfc_infra.prod.ecs_cluster_name
        log_group           = var.tfc_infra.prod.log_group_name
        execution_role_name = var.tfc_infra.prod.execution_role_name
        task_role_name      = var.tfc_infra.prod.task_role_name
        region              = var.tfc_infra.prod.region
        subnets             = var.tfc_infra.prod.private_subnets
        security_group_ids  = [var.tfc_infra.prod.security_group_id]
        alb {
          load_balancer_arn = var.tfc_infra.prod.alb_arn
          subnets           = var.tfc_infra.prod.public_subnets
        }
      }
    }
  }
}

variable "tfc_infra" {
  default = dynamic("terraform-cloud", {
    organization = "{{ .TfcOrgName }}"
    workspace    = "{{ .ProjectName }}"
  })
  type        = any
  sensitive   = false
  description = "all outputs from this app's tfc workspace"
}
