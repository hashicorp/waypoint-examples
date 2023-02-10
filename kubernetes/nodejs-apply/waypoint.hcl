# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "kubernetes-apply-nodejs"

app "apply-nodejs-web" {
  labels = {
    "service" = "apply-nodejs-web",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "apply-nodejs-web"
        tag   = "1"
        local = true
      }
    }
  }

  deploy {
    use "kubernetes-apply" {
      // Template the directory so that we process each file in the directory
      // as a template. This lets us inject the artifact from the previous step.
      path = templatedir("${path.app}/k8s")

      // This label determines what resources we own. Any that aren't present
      // in our folder that match this label will be deleted.
      prune_label = "app=myapp"

      // This is a list of Kubernetes Objects that are allowed to be pruned.
      // Specify them as group/version/kind (e.g: apps/v1/Deployment).
      // See https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply --prune-allowlist
      prune_whitelist = ["apps/v1/Deployment"]
    }
  }
}
