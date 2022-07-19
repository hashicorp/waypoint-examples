project = "kubernetes-nodejs-helm"

app "nodejs-helm-web" {
  labels = {
    "service" = "nodejs-helm-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "nodejs-helm-web"
        tag   = gitrefpretty()
        local = true
      }
    }
  }

  deploy {
    use "helm" {
      name  = app.name
      chart = "${path.app}/helm"

      // We use a values file so we can set the entrypoint environment
      // variables into a rich YAML structure. This is easier than --set
      values = [
        file(templatefile("${path.app}/values.yaml.tpl")),
      ]

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
