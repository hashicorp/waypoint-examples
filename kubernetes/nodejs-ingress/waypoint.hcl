project = "example-nodejs-ingress"

app "example-nodejs-ingress" {
  labels = {
    "service" = "example-nodejs-ingress",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "example-nodejs-ingress"
        tag   = "1"
        local = true
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      ingress "http" {
        path_type = "Prefix"
        path      = "/"
      }
    }
  }
}
