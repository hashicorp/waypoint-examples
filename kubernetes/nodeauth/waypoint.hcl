# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "example-nodejs"

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image    = var.image
        tag      = var.tag
        auth {
          username = var.registry_username
          password = var.registry_password
        }
        local    = var.registry_local
      }
    }
  }

  deploy {
    use "kubernetes" {}
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    path = "docker/nodejs"
    ref = "test-alpha"
  }
}

variable "image" {
  default     = "team-waypoint-dev-docker-local.artifactory.hashicorp.engineering/alpha-node"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "tag" {
  default     = "latest"
  type        = string
  description = "Image tag for the image"
}

variable "registry_local" {
  default     = false
  type        = bool
  description = "Set to enable local or remote container registry pushing"
}

variable "registry_username" {
  default = "test"
  type        = string
  sensitive   = true
  description = "username for container registry"
}

variable "registry_password" {
  default = "test"
  type        = string
  sensitive   = true
  description = "password for container registry" // don't hack me plz
}
