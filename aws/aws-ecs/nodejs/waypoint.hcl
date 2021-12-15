project = "example-nodejs"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/waypoint-examples.git"
    path = "aws/aws-ecs/nodejs"
    ref  = "ecs-remote-nodejs"
  }
}

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs"
    "env"     = "dev"
  }

  build {
    use "pack" {}

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
