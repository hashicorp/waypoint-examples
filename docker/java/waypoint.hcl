project = "example-java"

app "example-java" {
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

config {
  env = {
    DATABASE_URL = "postgresql://example.com:5432"
  }
}

