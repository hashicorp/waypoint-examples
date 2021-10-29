project = "go-multiworkspace"

app "backend" {

  config {
    env = {
      "CONFIG_PATH" = "/opt/config/config.yml"
    }

    workspace "default" {
      file = {
        "/opt/config/config.yml" = configdynamic("vault", {
          path = "config/data/go-multiworkspace/dev"
          key  = "data/config.yml"
        })
      }
    }

    workspace "prod" {
      file = {
        "/opt/config/config.yml" = configdynamic("vault", {
          path = "config/data/go-multiworkspace/prod"
          key  = "data/config.yml"
        })
      }
    }
  }

  build {
    use "docker" {}
    registry {
      use "aws-ecr" {
        region     = "us-east-2"
        repository = "acmecorp"
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
    use "kubernetes" {

      # Use the dev kubernetes namespace with the dev workspace, and prod with prod.
      # Error on any other workspace.
      namespace = {
        "default"  = "dev"
        "prod" = "prod"
      }[workspace.name]

      probe_path = "/health"

      service_account = "go-multiworkspace"
      service_port = 8080
    }
  }

  release {
    use "kubernetes" {

      # Use the dev kubernetes namespace with the dev workspace, and prod with prod.
      # Error on any other workspace.
      namespace = {
        "default"  = "dev"
        "prod" = "prod"
      }[workspace.name]

      load_balancer = true

      annotations = {

        # Assign an internal load balancer in dev, and external in prod
        "service.beta.kubernetes.io/aws-load-balancer-internal" = {
          "default"  = "true"
          "prod" = "false"
        }[workspace.name]

        #        # Use the correct cert for the workspace
        #        "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = {
        #          "dev"  = "dev-cert-arn"
        #          "prod" = "prod-cert-arn"
        #        }[workspace.name] 

      }
    }
  }
}

