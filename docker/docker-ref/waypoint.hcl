project = "docker-ref-example"

runner {
  enabled = true
  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples"
    ref  = "nomad-remote-ops"
    path = "docker/docker-ref"
  }
}

app "docker-ref-nodejs" {
  build {
    use "docker-ref" {
      image = "hashicorp/waypoint"
      tag   = "latest"
    }
  }

  deploy {
    use "docker" {}
  }
}
