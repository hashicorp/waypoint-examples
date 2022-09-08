project = "gcp-nodejs"

app "gcp-nodejs-web" {
  labels = {
    "service" = "gcp-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}

    registry {
      use "docker" {
        image = "gcr.io/<my-project-id>/example-nodejs"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "google-cloud-run" {
      project  = "<my-project-id>"
      location = "us-east1"

      port = 5000

      static_environment = {
        "NAME" : "World"
      }

      capacity {
        memory                     = 128
        cpu_count                  = 1
        max_requests_per_container = 10
        request_timeout            = 300
      }

      auto_scaling {
        max = 2
      }
    }
  }

  release {
    use "google-cloud-run" {}
  }
}