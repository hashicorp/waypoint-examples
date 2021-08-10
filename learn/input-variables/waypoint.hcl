project = "example/inputvars-go"

app "example-inputvars-go" {
  labels = {
    "service" = "example-inputvars-go",
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
	default     = "waypoint-test/example-inputvars-go"
	type        = string
	description = "Image name for the built image in the Docker registry."
}
variable "tag" {
	default     = "latest"
	type        = string
	description = "The tab for the built image in the Docker registry."
}