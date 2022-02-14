project = "waypoint-apollo-lambda"

app "waypoint-apollo-lambda" {
  build {
    use "docker" {
      buildkit = true
      platform = "amd64"
    }

    registry {
      use "aws-ecr" {
        region     = "us-east-1"
        repository = "waypoint-apollo-lambda"
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
    use "aws-lambda" {
      region = "us-east-1"
      memory = 256
    }
  }

  release {
    use "aws-alb" {

    }
  }
}