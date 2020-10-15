project = "example-dotnet"

app "web" {
  labels = {
    "service" = "example-dotnet",
    "env"     = "dev"
  }
  build {
    use "docker" {}
  }

  # Deploy to Docker
  deploy {
    use "docker" {
      service_port = 80
    }
  }
}
