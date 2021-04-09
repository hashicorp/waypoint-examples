project = "example-nodejs"

app "example-nodejs" {

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "nodejs-example"
        tag   = "1"
        local = true
      }
    }
  }

  deploy {
    use "nomad" {
      // these options both default to the values shown, but are left here to
      // show they are configurable
      datacenter = "dc1"
      namespace  = "default"
    }
  }

}
