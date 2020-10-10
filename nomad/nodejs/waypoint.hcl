project = "example-nodejs"

app "example-nodejs" {

  build {
    use "pack" {}
    registry {
        use "docker" {
          image = "nodejs-example"
          tag = "latest"
          local = true
        }
    }
 }

  deploy { 
    use "nomad" {
      datacenter = "dc1"
    }
  }

}
