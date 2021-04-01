project = "example-python"

app "example-python" {
  labels = {
    "service" = "example-python",
    "env" = "dev"
  }

  build {
    use "docker" {}
    registry {
      use "aws-ecr" {
        region = "us-east-1"
        repository = "waypoint-example"
        tag = "latest"
      }
    }
  }

  deploy { 
    use "aws-ecs" {
      region = "us-east-1"
      memory = "512"
    }
  }
}
