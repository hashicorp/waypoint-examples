project = "tfdemo"

app "kubernetes-nodejs-web" {
  config {
    env = {
      "DB_URL" = "dev.example.com"
    }

    workspace "production" {
      env = {
        "DB_URL" = "prod.example.com"
      }
    }
  }

  labels = {
    "service" = "kubernetes-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "team-waypoint-dev-docker-local.artifactory.hashicorp.engineering/ctsk8snodejs"
        tag   = "latest"

        username = var.registry_username
        password = var.registry_password
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      // Kube secret for pulling image from registry
      image_secret = var.registrycreds_secret
    }
  }

  release {
    use "kubernetes" {
      // Sets up a load balancer to access released application
      load_balancer = true
      port          = var.port
    }
  }
}

// On-Demand Runner configuration
# runner {
#   enabled = true

#   data_source "git" {
#     url  = "https://github.com/hashicorp/waypoint-examples.git"
#     ref = "refs/heads/nodejs-remote"
#     path = "kubernetes/nodejs"
#   }

#   # profile="kube_vault"
# }

// Variables
variable "registrycreds_secret" {
  default     = "registrycreds"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
}

variable "registry_username" {
  # default = dynamic("vault", {
  #   path = "secret/data/jfrogcreds"
  #   key = "/data/username"
  # })
  default = "testing"
  type        = string
  sensitive   = true
  description = "username for container registry"
}

variable "registry_password" {
  # default = dynamic("vault", {
  #   path = "secret/data/jfrogcreds"
  #   key = "/data/password"
  # })
  default = "testing"
  type        = string
  sensitive   = true
  description = "password for registry"
}

variable "port" {
  type = number
  # default = 1
  default = {
    "default"    = 3030
    "production" = 8080
  }[workspace.name]
}
