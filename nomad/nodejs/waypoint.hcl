project = "nomad-nodejs"

runner {
  profile = "nomad-task-launcher-test-profile"
}

app "nomad-nodejs-web" {
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
      // these options both default to the values shown, but are left here to
      // show they are configurable
      datacenter = "dc1"
      namespace  = "default"
    }
  }

}

variable "username" {
  type = string
}
variable "password" {
  type = string
}
