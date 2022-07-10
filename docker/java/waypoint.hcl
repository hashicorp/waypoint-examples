project = "example-java"

pipeline "test" {
  step "build" {
    use "build" {
      disable_push = true
    }
  }
}

app "example-java" {
  runner {
      profile = "test"
  }

  build {
    use "pack" {
      builder = "gcr.io/buildpacks/builder:v1"
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
    use "docker" {
      service_port = 8080
    }
  }
}
