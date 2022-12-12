# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "example-python"

app "example-python" {
  labels = {
    "service" = "example-python",
    "env"     = "dev"
  }

  build {
    use "docker" {}
  }

  deploy {
    use "docker" {
      service_port = 8080
    }
  }
}
