project = "kubernetes-nodejs"

app "kubernetes-nodejs-web" {
  labels = {
    "service" = "kubernetes-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "192.168.147.119:5000/kubernetes-nodejs-web"
        tag   = "latest"
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

// On-Demand Runner configuration
runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    ref = "refs/heads/nodejs-remote"
    path = "kubernetes/nodejs"
  }
}
