project = "nginx-project-pipeline"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }


app "web" {

  runner {
    profile = "local-docker"
  }
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "ttl.sh/izaak-test-docker-static"
        tag   = "5m"
      }
    }
  }

  deploy {
    use "docker" {
    }
  }
}

pipeline "up" {
  step "up" {
    use "up" {}
  }
}
