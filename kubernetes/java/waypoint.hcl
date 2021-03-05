project = "example-java"

app "example-java" {
    build {
        use "pack" {
            builder="gcr.io/buildpacks/builder:v1"
        }
        registry {
              use "docker" {
                image = "localhost:5000/example-java"
                tag   = "latest"
                local = false
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
