project = "kubernetes-nodejs"

app "kubernetes-nodejs-web" {
  labels = {
    "service" = "kubernetes-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "registry.services.demophoon.com/xxtest"
        tag   = "latest"
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
      // Sets up a load balancer to access released application
      load_balancer = true
      port          = 3000
    }
  }
}
