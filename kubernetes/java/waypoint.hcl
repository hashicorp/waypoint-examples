project = "example-java"

app "example-java" {
  build {
    use "pack" {
      builder="gcr.io/buildpacks/builder:v1"
    }
    registry {
      use "docker" {
        image = "example-java"
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
