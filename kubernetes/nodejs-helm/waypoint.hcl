project = "example-nodejs"

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "example-nodejs"
        tag   = "1"
        local = true
      }
    }
  }

  deploy {
    use "helm" {
      name  = app.name
      chart = "${path.app}/helm"

      set {
        name  = "image.repository"
        value = artifact.image
      }

      set {
        name  = "image.tag"
        value = artifact.tag
      }
    }
  }
}
