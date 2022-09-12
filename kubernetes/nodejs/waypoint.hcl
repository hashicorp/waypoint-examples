project = "example-nodejs"

#pipeline "example" {
#  step "run-some-code" {
#    image_url = "https://localhost:5000/waypoint-odr:dev"
#
#    use "exec" {
#      # executes a binary test with some arguments
#      command = "test"
#      args    = ["--full", "test-all"]
#    }
#  }
#}

pipeline "simple-nested" {
  step "build" {
    use "build" { }
  }

  step "deploy" {
    pipeline "deploy" {
      step "deploy" {
        use "deploy" {
        }
      }
      step "release" {
        use "release" {
          prune = true
        }
      }
    }
  }
}


app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }


  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "registry.services.demophoon.com/cassietest"
        tag   = "latest"
        local = false
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
      // Sets up a load balancer to access released application
      load_balancer = true
      port          = 3000
    }
  }
}
