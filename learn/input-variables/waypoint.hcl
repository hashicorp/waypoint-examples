project = "learn/inputvars-go"

app "inputvars-go-app" {
  labels = {
    "service" = "inputvars-go-app",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = var.image
        tag   = var.tag
        local = true
      }
    }
  }

  deploy {
    use "docker" {}
  }
}

variable "image" {
	default     = "waypoint-test/learn-inputvars-go"
	type        = string
	description = "Image name for the built image in the Docker registry."
}
variable "tag" {
	default     = "latest"
	type        = string
	description = "The tab for the built image in the Docker registry."
}