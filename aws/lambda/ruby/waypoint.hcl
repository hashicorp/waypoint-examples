project = "learn-waypoint-lambda"

app "learn-waypoint-lambda" {
  build {
    use "docker" {}

    registry {
      use "aws-ecr" {
        region = "us-east-1"
        repository = "learn-waypoint-lambda"
        tag = "howdy-waypoint-lambda"
      }
    }
  }

  deploy { 
    use "aws-lambda" {
      region = "us-east-1"
    }
  }

  release {
    use "aws-alb" {
    }
  }
}
