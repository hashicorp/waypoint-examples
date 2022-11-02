project = "example-nodejs"

pipeline "example-nodejs" {
  step "test" {
    image_url = "hashicorp/waypoint-odr:latest"

    use "exec" {
      command = "echo"
      args    = [var.message]
    }
  }

  step "build-example-nodejs" {
    use "build" {}
  }

  step "deploy-example-nodejs" {
    use "deploy" {}
  }
}

app "example-nodejs" {
  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "devopspaladin/nodejs-example"
        tag   = "1"
        auth {
          username = var.username
          password = var.password
        }
      }
    }
  }

  deploy {
    use "nomad" {
      datacenter = "dc1"
      namespace  = "default"
    }
  }
}

variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  type      = string
  sensitive = true
}

variable "message" {
  type    = string
  default = "tatakae"
}
