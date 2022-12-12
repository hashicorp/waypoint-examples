# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "learn-static-go"

app "static-go" {
  labels = {
    "service" = "static-go",
    "env"     = "dev"
  }

  config {
    env = {
      SALE_PERCENT = "50%"
    }
  }

  build {
    use "pack" {}
  }

  deploy {
    use "docker" {}
  }
}
