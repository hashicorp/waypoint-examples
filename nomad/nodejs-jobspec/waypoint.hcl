project = "nomad-jobspec-nodejs"

app "nodejs-jobspec-web" {
  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "nodejs-jobspec-web"
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

  release {
    use "nomad-jobspec-canary" {
      groups = [
        "app"
      ]
      fail_deployment = false
    }
  }
}
