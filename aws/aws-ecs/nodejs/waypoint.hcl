project = "aws-ecs-nodejs"

app "ecs-nodejs-web" {
  labels = {
    "service" = "ecs-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "aws-ecr" {
        region     = "us-east-1"
        repository = "waypoint-example"
        tag        = "latest"
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
