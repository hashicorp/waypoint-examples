# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "example-svelte"

app "example-svelte" {
  labels = {
    "service" = "example-svelte",
    "env"     = "dev"
  }

  build {
    use "docker" {}
  }

  deploy {
    use "docker" {
      service_port = 5000
    }
  }
}

