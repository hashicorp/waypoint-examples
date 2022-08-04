project = "example-go"

app "app-1" {
  labels = {
    "service" = "app-1",
    "env"     = "dev"
  }

  build {
    use "pack" {}
  }

  deploy {
    use "docker" {}
  }
}

app "app-2" {
  labels = {
    "service" = "app-2",
    "env"     = "dev"
  }

  build {
    use "pack" {}
  }

  deploy {
    use "docker" {}
  }
}
