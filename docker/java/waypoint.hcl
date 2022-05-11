variable "registry_username" {
  type = string
  default = ""
  env = ["REGISTRY_USERNAME"]
}

variable "registry_password" {
  type = string
  sensitive = true
  default = ""
  env = ["REGISTRY_PASSWORD"]
}

variable "registry_imagename" {
  type = string
  default = ""
  env = ["REGISTRY_IMAGENAME"]
}


project = "example-java"

app "example-java" {
  runner {
      profile = "test"
  }

  build {
    use "pack" {
      builder = "gcr.io/buildpacks/builder:v1"
    }
  
  
    registry {
      use "docker" {
        image = "${var.registry_username}/${var.registry_imagename}"
        tag   = "${gitrefpretty()}"
        username = var.registry_username
        password = var.registry_password
        local = false
      }
    }
  }

  deploy {
    use "docker" {
      service_port = 8080
    }
  }
}
