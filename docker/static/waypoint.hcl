project = "nginx-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }


app "web" {
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = ttl.sh/izaak-test-docker-static
        tag   = "5m"
      }
    }
  }

  deploy {
    use "docker" {
    }
  }
}
