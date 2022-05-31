project = "example-nodejs"

app "example-nodejs" {

  build {
    use "docker-pull" {
      image              = "node"
      tag                = "latest"
      disable_entrypoint = true
      auth {
        username = var.user
        password = var.pass
      }
    }
    registry {
      use "docker" {
        image = "devopspaladin/nodejs-example"
        tag   = "latest"
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

variable "user" {
  type      = string
  sensitive = true
}

variable "pass" {
  type      = string
  sensitive = true
}
