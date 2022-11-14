project = "example-go"

app "example-go" {
  labels = {
    "service" = "example-go",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        # Replace with your docker image name (i.e. registry.hub.docker.com/library/go-k8s)
        image = "example-go"
        tag = gitrefpretty()
        local = true
      }
    }
  }

  deploy {
    use "docker" {}
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    path = "docker/go"
    ref = "docker-go-remote"
  }
}
