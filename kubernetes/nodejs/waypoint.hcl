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
        image = "devopspaladin/kubernetes-nodejs-web"
        tag   = "1"
        local = false
	username = var.user
	password = var.password
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

variable "user" {
  type = string
  default = "devopspaladin"
}

variable "password" {
  default = dynamic("kubernetes", {
      name   = "reg-pass" # Secret name
      key    = "password"
      secret = true
  })
 type = string
}
