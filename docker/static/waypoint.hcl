project = "nginx-project-logsmaybe2"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }


app "web" {
  build {
    use "docker" {
    }
  }

  deploy {
    use "docker" {
    }
  }
}
