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
          image = "nodejs-example"
          tag = "latest"
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
      port = 80
    }
  }
}
