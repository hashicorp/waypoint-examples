project = "example-nodejs"

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
    use "nomad-jobspec" {
      // Templated to perhaps bring in the artifact from a previous
      // build/registry, entrypoint env vars, etc.
      jobspec = templatefile("${path.app}/app.nomad.tpl")
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
