project = "go-k8s"

app "go-k8s" {
  labels = {
    "service" = "go-k8s",
    "env"     = "dev"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        # Replace with your docker image name (i.e. registry.hub.docker.com/library/go-k8s)
        image = "your-image-here"
        tag = gitrefpretty()
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      service_port = 3000
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
    }
  }
}
