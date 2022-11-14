project = "example-go"

app "example-go" {
  labels = {
    "service" = "example-go",
    "env"     = "dev"
  }

  build {
    use "pack" {}
        registry {
      use "docker" {
        image = var.push_image
        tag   = var.push_tag
        auth {
          username = var.push_registry_username
          password = var.push_registry_password
        }
      }
    }
  }

  deploy {
    use "docker" {}
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    path = "docker/go"
    ref = "docker-go-remote"
  }
}

// Variables for use when pushing images to a registry
variable "push_image" {
  default     = "catsby/example-go-pull"
  type        = string
  description = "Image name for the built image to push to the Docker registry."
}

variable "push_tag" {
  default = {
    "default"    = "dev"
    "production" = "latest"
  }[workspace.name]
  type        = string
  description = "Tag to use when pushing the image to a registry"
}

variable "push_registry_username" {
  default     = "catsby"
  type        = string
  sensitive   = true
  description = "username for container push registry"
}

variable "push_registry_password" {
  default     = "nope"
  type        = string
  sensitive   = true
  description = "password for push registry"
}
