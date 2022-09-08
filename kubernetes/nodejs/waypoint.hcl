project = "workspace-steps"

pipeline "nodes" {
  step "up" {
    use "up" {
      prune = true
    }
  }

  step "do-it" {
    # image_url = "localhost:5000/waypoint-odr:dev"
    image_url = "alpine:3.16.2"
    use "exec" {
      command = "echo"
      args    = ["this works!"]
    }
  }
}

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
      port          = 3000
    }
  }
}

// On-Demand Runner configuration
runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    ref = "refs/heads/nodejs-remote"
    path = "kubernetes/nodejs"
  }
}

// Variables
variable "registrycreds_secret" {
  default     = "registrycreds"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
}

variable "registry_username" {
  default = dynamic("vault", {
    path = "secret/data/jfrogcreds"
    key = "/data/username"
  })
  type        = string
  sensitive   = true
  description = "username for container registry"
}

variable "registry_password" {
  default = dynamic("vault", {
    path = "secret/data/jfrogcreds"
    key = "/data/password"
  })
  type        = string
  sensitive   = true
  description = "password for registry"
}
