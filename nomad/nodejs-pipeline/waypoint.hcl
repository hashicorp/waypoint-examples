project = "example-nodejs"

pipeline "example-nodejs" {
  step "build-example-nodejs" {
    use "build" {}
  }

  step "deploy-example-nodejs" {
    use "deploy" {}
  }

  step "test" {
    image_url = "waypoint-odr:dev"

    use "exec" {
      command = "echo done!"
    }
  }
}

app "example-nodejs" {
  config {
    env = {
      static = "hello"
    }
  }

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
