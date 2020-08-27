project = "example-nodejs"

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env" = "dev"
  }

  build {
    use "pack" {}
    registry {
        use "docker" {
          image = "harbor.humblelab.com/library/nodejs-example"
          tag = "latest"
          //local = true
          //encoded_auth
        }
    }
 }

  deploy { 
    use "kubernetes" {
    // kubeconfig =
    // context = 
    // count = 
    probe_path = "/"
    // scratch_path =
    // image_secret
    // static_environment
    }
  }

  release {
    use "kubernetes" {
      // kubeconfig =
      // context =
      load_balancer = true
      port = 80
      // node_port =

    }
  }
}
