project = "go-gitops-0"

variable "image" {
  default     = "your.own.container.registry.example.com/go"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "tag" {
  default     = "latest"
  type        = string
  description = "Image tag for the image"
}

variable "registry_username" {
  default = dynamic("vault", {
    path = "config/data/secret/registry"
    key  = "data/registry_username"
  })
  type        = string
  sensitive   = true
  description = "username for container registry"
}

variable "registry_password" {
  default = dynamic("vault", {
    path = "config/data/secret/registry"
    key  = "data/registry_password"
  })
  type        = string
  sensitive   = true
  description = "password for registry" // DO NOT COMMIT YOUR PASSWORD TO GIT
}

variable "regcred_secret" {
  default     = "regcred"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
}

app "go" {
  build {
    use "pack" {}

    registry {
      use "docker" {
        image    = var.image
        tag      = var.tag
        username = var.registry_username
        password = var.registry_password
        local    = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path   = "/"
      image_secret = var.regcred_secret
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 3000
    }
  }
}
