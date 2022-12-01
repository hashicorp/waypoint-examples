project = "packer-plugin-project"

runner {
  enabled = true
  data_source "git" {
    url  = "https://github.com/paladin-devops/waypoint-examples"
    path = "docker/reactjs-packer"
    ref  = "packer-plugin-example"
  }

  poll {
    enabled  = true
    interval = "30s"
  }
}

variable "image" {
  default = dynamic("packer", {
    bucket  = "nginx"
    channel = "base"
    region  = "docker"
    cloud   = "docker"
  })
  type        = string
  description = "The name of the base image to use for building app Docker images."
}

app "packer-plugin-app" {
  build {
    use "docker" {
      dockerfile = templatefile("${path.app}/Dockerfile", {
        base_image = var.image
      })
    }
  }

  deploy {
    use "docker" {}
  }
}