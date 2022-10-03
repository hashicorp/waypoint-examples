project = "nginx-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }


app "web" {
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = format("ttl.sh/izaak-%s", lower(trim(base64encode(timestamp()), "=")))
        tag   = "1h"
      }
    }
  }

  deploy {
    use "docker" {
    }
  }
}
