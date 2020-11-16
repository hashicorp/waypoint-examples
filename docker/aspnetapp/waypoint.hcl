project = "example-dotnet"

app "web" {
  labels = {
    "service" = "example-dotnet",
    "env"     = "dev"
  }
  build {
    use "pack" {
      builder = "paketobuildpacks/builder:full"
    }
  }

  # Deploy to Docker
  deploy {
    use "docker" {
      service_port = 8080
    }
  }
}
