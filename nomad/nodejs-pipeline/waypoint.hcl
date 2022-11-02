project = "example-nodejs"

pipeline "example-nodejs" {
  step "test" {
    image_url = var.image_url 

    use "exec" {
      command = "echo"
      args    = ["tatakae"]
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

variable "image_url" {
  type    = string
  default = "hashicorp/waypoint-odr:latest"
}
