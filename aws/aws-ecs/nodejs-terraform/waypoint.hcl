project = "njs-ecs-tfc"

app "njs-ecs-tfc" {
  build {
    use "pack" {}
    registry {
      use "aws-ecr" {
        region     = "us-west-2"
        repository = "njs-ecs-tfc"
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
