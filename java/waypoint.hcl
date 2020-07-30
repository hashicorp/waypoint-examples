project = "example-java"

app "example-java" {
  labels = {
    "service" = "example-java",
    "env" = "dev"
  }

  build "pack" {}

  deploy "docker" {}
}
