project = "{{ .ProjectName }}"

app "{{ .ProjectName }}" {
  config {
    env = {
      "DATABASE_USERNAME" = dynamic("vault", {
        path = "{{ .ProjectName }}-database/creds/{{ .ProjectName }}-role"
        key  = "username"
      })

      "DATABASE_PASSWORD" = dynamic("vault", {
        path = "{{ .ProjectName }}-database/creds/{{ .ProjectName }}-role"
        key  = "password"
      })

      "DATABASE_NAME"     = var.tfc_infra.db.db_name
      "DATABASE_PORT"     = var.tfc_infra.db.dev_db_port
      "DATABASE_HOSTNAME" = var.tfc_infra.db.dev_db_hostname
    }

    workspace "prod" {
      env = {
        "DATABASE_PORT"     = var.tfc_infra.db.prod_db_port
        "DATABASE_HOSTNAME" = var.tfc_infra.db.prod_db_hostname
      }
    }
  }

  build {
    use "docker-ref" {
        image = var.tfc_infra.ecr_uri
        tag   = gitrefhash()
    }
  }

  deploy {
    # By default, use the AWS ECS plugin to deploy to the dev environment
    use "aws-ecs" {
      count = 1
      memory = 512
      cpu = 256
      service_port = 8080
      assign_public_ip = true
      logging {
        create_group = false
      }

      target_group_protocol         = "HTTP"
      target_group_protocol_version = "GRPC"

      health_check {
        grpc_code = "0,12"
        path      = "/grpc.health.v1.Health/Check"
        protocol  = "HTTP"
      }

      cluster             = var.tfc_infra.dev.ecs_cluster_name
      log_group           = var.tfc_infra.dev.log_group_name
      execution_role_name = var.tfc_infra.dev.execution_role_name
      task_role_name      = var.tfc_infra.dev.task_role_name
      region              = var.tfc_infra.dev.region
      subnets             = var.tfc_infra.dev.public_subnets
      security_group_ids  = [var.tfc_infra.dev.security_group_id]
      alb {
        load_balancer_arn = var.tfc_infra.dev.alb_arn
        subnets           = var.tfc_infra.dev.public_subnets
        certificate       = var.tfc_infra.acm_cert_arn
      }

      sidecar {
        name  = "datadog-agent"
        image = "public.ecr.aws/datadog/agent:latest"
        memory = 512

        static_environment = {
          ECS_FARGATE = "true"
        }

        secrets = {
          DD_API_KEY = var.datadog_api_key
        }
      }
    }

    workspace "prod" {
      use "aws-ecs" {
        count = 1
        memory = 512
        cpu = 256
        service_port = 8080
        assign_public_ip = true
        logging {
          create_group = false
        }

        target_group_protocol         = "HTTP"
        target_group_protocol_version = "GRPC"

        health_check {
          grpc_code = "0,12"
          path      = "grpc.health.v1.Health/Check"
          protocol  = "HTTP"
        }

        cluster             = var.tfc_infra.prod.ecs_cluster_name
        log_group           = var.tfc_infra.prod.log_group_name
        execution_role_name = var.tfc_infra.prod.execution_role_name
        task_role_name      = var.tfc_infra.prod.task_role_name
        region              = var.tfc_infra.prod.region
        subnets             = var.tfc_infra.prod.public_subnets
        security_group_ids  = [var.tfc_infra.prod.security_group_id]
        alb {
          load_balancer_arn = var.tfc_infra.prod.alb_arn
          subnets           = var.tfc_infra.prod.public_subnets
          certificate       = var.tfc_infra.acm_cert_arn
        }

        sidecar {
          name  = "datadog-agent"
          image = "public.ecr.aws/datadog/agent:latest"
          memory = 512

          static_environment = {
            ECS_FARGATE = "true"
          }

          secrets = {
            DD_API_KEY = var.datadog_api_key
          }
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

variable "datadog_api_key" {
  default = dynamic("vault", {
    path = "{{ .ProjectName }}-kv/data/datadog"
    key = "/data/api_key"
  })
  sensitive   = true
  type        = string
  description = "The API key for DataDog to send application metrics"
}
