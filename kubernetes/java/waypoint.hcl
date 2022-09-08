project = "kubernetes-java"

app "kubernetes-java-app" {
  build {
    use "pack" {
      builder="gcr.io/buildpacks/builder:v1"
    }
    registry {
      use "docker" {
        image = "kubernetes-java-app"
        tag   = "1"
        local = true
      }
    }
  }

  deploy {
    use "kubernetes" {
      namespace = "default"
      probe_path = "/"
      service_port = 8080
    }
  }

  release {
    use "kubernetes" {
      node_port = 32000
    }
  }
}
