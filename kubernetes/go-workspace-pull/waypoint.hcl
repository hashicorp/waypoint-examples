# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "go-k8s"

app "go-k8s" {
  labels = {
    "service" = "go-k8s",
    "env" = {
      "default"    = "dev"
      "production" = "latest"
    }[workspace.name]
  }

  build {
    // by default, build the Dockerfile
    use "docker" {}

    // in production, pull the latest "dev" image
    workspace "production" {
      use "docker-pull" {
        image = var.pull_image
        tag   = var.pull_tag
        auth {
          username = var.pull_registry_username
          password = var.pull_registry_password
        }
      }
    }

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
    use "kubernetes" {
      probe_path   = "/"
      service_port = 3000
      annotations  = labels
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 3000
    }
    workspace "production" {
      use "kubernetes" {
        load_balancer = true
        port          = 3030
      }
    }
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

// Variables for use when pulling an image from a registry
variable "pull_image" {
  default     = "catsby/example-go-pull"
  type        = string
  description = "Image name to pull with docker-pull."
}

variable "pull_tag" {
  default     = "dev"
  type        = string
  description = "Tag to use when pulling an image with docker-pull"
}

variable "pull_registry_username" {
  default     = "catsby"
  type        = string
  sensitive   = true
  description = "username for container pull registry"
}

variable "pull_registry_password" {
  default     = "nope"
  type        = string
  sensitive   = true
  description = "password for pull registry"
}

// Miscellaneous variables
variable "port" {
  type = number
  default = {
    "default"    = 3000
    "production" = 3030
  }[workspace.name]
  description = "Port number exposed to the outside, e.g. localhost:3000"
}


runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    path = "kubernetes/go-workspace-pull"
  }
}
