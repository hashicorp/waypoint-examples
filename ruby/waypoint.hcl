project = "example-ruby"

app "example-ruby" {
  labels = {
    "service" = "example-ruby",
    "env" = "dev"
  }

  build "pack" {}

  deploy "docker" {}
}
