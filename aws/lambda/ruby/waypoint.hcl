# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "learn-waypoint-lambda"

app "learn-waypoint-lambda-function" {
  build {
    use "docker" {}

    registry {
      use "aws-ecr" {
        region = "us-west-2"
        repository = "learn-waypoint-lambda"
        tag = "howdy-waypoint-lambda"
      }
    }
  }

  deploy { 
    use "aws-lambda" {
      region = "us-west-2"
    }
  }

  release {
    use "aws-alb" {
    }
  }
}