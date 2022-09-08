project = "aws-ecs-python"

app "ecs-python" {
  labels = {
    "service" = "ecs-python",
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
