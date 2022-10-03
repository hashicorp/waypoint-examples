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
        image = "localhost:5000/date-busybox"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/date.nomad.hcl")
    }
  }
}
