# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "aws-ecs-nodejs"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples"
    path = "aws/aws-ecs/nodejs"
    ref = "ecsnodejsrunner"
  }
}

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
