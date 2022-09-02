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
      cluster = var.ecs_cluster
    }
  }
}

variable "ecs_cluster" {
  default = dynamic("terraform-cloud", {
    organization = "hc-waypoint"
    workspace    = "hashiconf-demo"
    output       = "ecs_cluster_name"
  })
  type    = string
  sensitive   = false
  description = "name of the ecs cluster to deploy into"
}
