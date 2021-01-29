project = "example-go"

app "example-go" {
  labels = {
    "service" = "example-go",
    "env"     = "dev"
  }

  config {
    env = {
      SALE_PERCENT = "50%"
    }
  }

  build {
    use "pack" {}
  }

  deploy {
    use "docker" {}
  }
}
