project = "example-java"
runner {
  profile="dev"
}

app "example-java" {
  runner {
    profile="dev"
  } 
  build {
    use "pack" {
      builder = "gcr.io/buildpacks/builder:v1"
    }
  }
  deploy {
    use "docker" {
      service_port = 8080
    }
  }
}
