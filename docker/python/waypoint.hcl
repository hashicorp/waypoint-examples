project = "example-python"

app "example-python" {
  labels = {
    "service" = "example-python",
    "env" = "dev"
  }

  build {
    use "docker" {}
  }

  deploy { 
    use "docker" {}
  }
}
