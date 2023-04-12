# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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
        image    = "localhost:6000/alpha-node"
        tag      = "latest"
        local    = true
      }
    }
  }

  deploy {
    use "docker" {}
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/hashicorp/waypoint-examples.git"
    path = "docker/nodejs"
    ref = "test-alpha"
  }
}
