project = "example-python"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/waypoint-examples.git"
    path = "aws/aws-ecs/python"
    ref  = "ecs-remote-nodejs"
  }
}

app "example-python" {
  labels = {
    "service" = "example-python"
    "env"     = "dev"
  }

  build {
    use "docker" {}

    registry {
      use "aws-ecr" {
        region     = "us-west-2"
        repository = "waypoint-example"
        tag        = "latest"
      }
    }
  }

  deploy {
    use "aws-ecs" {
      region = "us-west-2"
      memory = "512"
    }
  }
}
