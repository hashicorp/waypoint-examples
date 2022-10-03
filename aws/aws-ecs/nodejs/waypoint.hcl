project = "aws-ecs-nodejs"

runner {
  enabled = true
  profile = "ecs-watch-task-testing"
  
  data_source "git" {
    url = "https://github.com/hashicorp/waypoint-examples"
    path = "aws/aws-ecs/nodejs"
    ref = "nomad-remote-ops"
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
        region     = "ca-central-1"
        repository = "waypoint-example"
        tag        = "latest"
      }
    }
  }

  deploy {
    use "aws-ecs" {
      region = "ca-central-1"
      memory = "512"
    }
  }
}
