project = "workspace-steps"

pipeline "local" {
  step "one" {
    image_url = "catsby/echodocker:latest"
    # image_url = "http://192.168.147.119:5000/echodocker"
    use "exec" {
      command = "./echodocker; sleep 15"
      # args = ["./echodocker"]
    }
  }
}

pipeline "nodes" {
  # step "up" {
  #   use "up" {
  #     prune = true
  #   }
  # }

  step "do-it" {
    # image_url = "localhost:5000/waypoint-odr:dev"
    image_url = "alpine:3.16.2"
    use "exec" {
      command = "echo"
      args    = ["this works!"]
    }
  }
}

pipeline "ups" {
  step "up-dev" {
    use "up" {}
  }

  step "up-prod" {
    workspace = "production"
    use "up" {}
  }
}

app "kubernetes-nodejs-web" {
  config {
    env = {
      "DB_URL" = "dev.example.com"
      "WP_WORKSPACE" = "default"
    }

    workspace "production" {
      env = {
        "DB_URL" = "prod.example.com"
        "WP_WORKSPACE" = "production"
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

variable "port" {
  type = number
  # default = 1
  default = {
    "default"    = 3000
    "production" = 8080
  }[workspace.name]
}

variable "wp_workspace" {
  type = string
  default = workspace.name
}
