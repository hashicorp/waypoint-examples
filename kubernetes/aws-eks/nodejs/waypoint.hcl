project = "kubernetes-eks-nodejs"

app "eks-nodejs-web" {
  labels = {
    "service" = "eks-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "aws-ecr" {
        region     = "us-east-1"
        repository = "eks-nodejs-web"
        tag        = "latest"
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 80
    }
  }
}