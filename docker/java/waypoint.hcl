project = "example-java"

pipeline "tester" {
  step "build" {
    use "build" {
      disable_push = true
    }
  }

  step "deploy" {
    use "deploy" {}
  }
}

app "example-java" {
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
