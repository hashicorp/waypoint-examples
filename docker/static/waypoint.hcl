project = "nginx-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

app "web" {
  build {
    use "docker" {
#	buildkit = true
	platform = "linux/amd64"
	disable_entrypoint = true
    }
  }

  deploy {
    use "docker" {
    }
  }
}
