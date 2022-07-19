project = "kubernetes-go-multiapp-k8s-ingress"

variable "namespace" {
  default     = "ingress-nginx"
  type        = string
  description = "The namespace to deploy and release to in your Kubernetes cluster."
}

app "go-multiapp-one" {
  labels = {
    "service" = "go-multiapp-one",
    "env"     = "dev"
  }

  config {
    env = {
      WP_NODE = "ONE"
    }
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "go-multiapp-one"
        tag   = "1"
        local = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      namespace  = var.namespace
    }
  }

  release {
    use "kubernetes" {
      namespace = var.namespace

      ingress "http" {
        path_type = "Prefix"
        path      = "/app-one"
      }
    }
  }

}


app "go-multiapp-two" {
  labels = {
    "service" = "go-multiapp-two",
    "env"     = "dev"
  }

  config {
    env = {
      WP_NODE = "TWO"
    }
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "go-multiapp-two"
        tag   = "1"
        local = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      namespace  = var.namespace
    }
  }

  release {
    use "kubernetes" {
      namespace = var.namespace

      ingress "http" {
        path_type = "Prefix"
        path      = "/app-two"
      }
    }
  }
}

app "default-app" {
  labels = {
    "service" = "default-app",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "default-app"
        tag   = "1"
        local = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      namespace  = var.namespace
    }
  }

  release {
    use "kubernetes" {
      namespace = var.namespace

      ingress "http" {
        default   = true
        path_type = "Prefix"
        path      = "/"
      }
    }
  }
}
