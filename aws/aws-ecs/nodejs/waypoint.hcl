project = "nodejs-on-tfc-cluster"

app "nodejs-on-tfc-cluster" {
  build {
    use "pack" {}
    registry {
      use "aws-ecr" {
        region     = "us-west-2"
        repository = "nodejs-on-tfc-cluster"
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
