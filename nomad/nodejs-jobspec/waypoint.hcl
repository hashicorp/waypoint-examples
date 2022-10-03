project = "nomad-jobspec-nodejs"

runner {
  enabled = true
  profile = "nomad-profile"

  data_source "git" {
    url = "https://github.com/hashicorp/waypoint-examples"
    path = "nomad/nodejs-jobspec"
    ref = "nomad-remote-ops"
  }
}

app "nodejs-jobspec-web" {
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
      jobspec = templatefile("${path.app}/app.nomad.tpl", {
        env = workspace.name
      })
    }
  }

  release {
    use "nomad-jobspec-canary" {
      groups = [
        "app"
      ]
      fail_deployment = false
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
