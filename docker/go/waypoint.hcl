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
        image = "ttl.sh/teresa-example-go"
        tag   = "1h"
      }
    }
  }

  deploy {
    use "docker" {}
  }
}
