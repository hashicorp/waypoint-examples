project = "kubernetes-nodejs-ingress"

app "nodejs-ingress-app" {
  labels = {
    "service" = "nodejs-ingress-app",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "nodejs-ingress-app"
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
