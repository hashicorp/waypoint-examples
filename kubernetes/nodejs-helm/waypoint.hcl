project = "example-nodejs-helm"

variable "image" {
  default     = "example-nodejs"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "registry_local" {
  default     = true
  type        = bool
  description = "Whether or not to push the built container to a remote registry"
}

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = var.image
        tag   = "1"
        local = var.registry_local
      }
    }
  }

  deploy {
    use "helm" {
      name  = "my-deployment"
      chart = "${path.app}/charts"

      set {
        name  = "deployment.image.name"
        value = artifact.image
      }

      set {
        name  = "deployment.image.tag"
        value = artifact.tag
      }
    }
  }
}
