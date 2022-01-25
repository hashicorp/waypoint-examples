project = "example-java"

app "example-java" {
  runner {
    profile = "prod"
  }
  build {
    use "pack" {
      builder="gcr.io/buildpacks/builder:v1"
    }
    registry {
      use "docker" {
        image = "example-java"
        tag   = "1"
        local = true
      }
    }  
  }

  deploy {
    use "kubernetes" {
      context = {
        "default" = "arn:aws:eks:us-east-2:797645259670:cluster/xx-test-dev"
        "prod"    = "arn:aws:eks:us-east-2:797645259670:cluster/xx-test-prod"
      }[workspace.name]

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
