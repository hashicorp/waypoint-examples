project = "example-nodejs"

pipeline "example" {
  step "run-some-code" {
    image_url = "https://localhost:5000/waypoint-odr:dev"

    use "exec" {
      # executes a binary test with some arguments
      command = "test"
      args    = ["--full", "test-all"]
    }
  }
}

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }


#  build {
#    use "pack" {}
#    registry {
#      use "docker" {
#        image = "example-nodejs"
#        tag   = "1"
#        local = true
#      }
#    }
#  }
#
#  deploy {
#    use "kubernetes" {
#      probe_path = "/"
#    }
#  }
#
#  release {
#    use "kubernetes" {
#      // Sets up a load balancer to access released application
#      load_balancer = true
#      port          = 3000
#    }
#  }
}
