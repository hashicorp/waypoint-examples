project = "example-nodejs"

app "example-nodejs" {

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
    }
  }
}
