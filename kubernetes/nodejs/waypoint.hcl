project = "kubernetes-nodejs"

runner {
  enabled = true
  
  data_source "git" {
    url = "https://github.com/hashicorp/waypoint-examples"
    path = "kubernetes/nodejs"
    ref = "nomad-remote-ops"
  }
}

app "kubernetes-nodejs-web" {
  labels = {
    "service" = "kubernetes-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "kubernetes-nodejs-web"
        tag   = "1"
        local = true
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
