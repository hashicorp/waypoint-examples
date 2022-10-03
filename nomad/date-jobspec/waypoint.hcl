project = "periodic-nomad-date"

runner {
  enabled = true
  profile = "nomad-profile"

  data_source "git" {
    url = "https://github.com/hashicorp/waypoint-examples"
    path = "nomad/nodejs-jobspec"
    ref = "nomad-remote-ops"
  }
}

app "date" {
  build {
    use "docker-pull" {
      image = "busybox"
      tag   = "latest"
    }
    registry {
      use "docker" {
        image = "devopspaladin/date-busybox"
        tag   = "latest"
        auth {
          username = var.username
          password = var.password
      }
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/date.nomad.hcl")
    }
  }
}

variable "username" {
  type = string
  sensitive = true
}

variable "password" {
  type = string
  sensitive = true
}
