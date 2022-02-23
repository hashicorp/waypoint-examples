project = "waypoint-apollo-lambda"

app "waypoint-apollo-lambda" {
  build {
    use "docker" {
      buildkit = true
      platform = "amd64"
    }

    registry {
      use "aws-ecr" {
        region     = var.region
        repository = var.aws_ecr_repository
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
    use "aws-lambda" {
      region = var.region
      memory = 256
    }
  }

  release {
    use "aws-alb" {}
  }
}

variable "aws_ecr_repository" {
  default     = "waypoint-apollo-lambda"
  type        = string
  description = "AWS ECR repository name"
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region"
}