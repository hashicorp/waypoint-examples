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
        # image    = "localhost:6000/alpha-node"
        image    = "192.168.147.241:6000/alpha-node"
        tag      = "latest"
        local    = false
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
