project = "kubernetes-java"

pipeline "nested" {
 step "build" {
    use "build" {}
  }
 step "deploy" {
   use "deploy" {}
 }
}

app "kubernetes-java-app" {
  
  build {
    use "pack" {
      builder="gcr.io/buildpacks/builder:latest"
    }
    registry {
      use "aws-ecr" {
        repository = "xx/tester"
        tag   = "1"
        region = "us-east-1"
      }
   }
  }

  deploy {
    use "kubernetes" {
      namespace = "default"
      probe_path = "/"
      service_port = 8080
    }
  }

  release {
    use "kubernetes" {
      node_port = 32000
    }
  }
}
