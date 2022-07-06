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
    use "nomad-jobspec" {
      // Templated to perhaps bring in the artifact from a previous
      // build/registry, entrypoint env vars, etc.
      jobspec = templatefile("${path.app}/app.nomad.tpl")
    }
  }
}
