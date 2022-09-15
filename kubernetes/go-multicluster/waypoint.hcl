project = "go-multicluster"

app "backend" {

  runner {
    profile = {
      "default" = "kubernetes-DEV"
      "dev"     = "kubernetes-DEV"
      "prod"    = "kubernetes-PROD"
    }[workspace.name]
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
      probe_path = "/health"
      service_port = 8080
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      annotations = {
        # Assign an internal load balancer in dev, and external in prod
        "service.beta.kubernetes.io/aws-load-balancer-internal" = {
          "default"  = "false"
          "dev"      = "false"
          "prod"     = "false"
        }[workspace.name]
      }
    }
  }
}

