project = "example-go"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/waypoint-examples.git"
    path = "docker/go"
    ref  = "ecs-remote-nodejs"
  }
}

app "example-go" {
  labels = {
    "service" = "example-go"
    "env"     = "dev"
  }

  build {
    use "pack" {}
  }

  deploy {
    use "docker" {}
  }
}
