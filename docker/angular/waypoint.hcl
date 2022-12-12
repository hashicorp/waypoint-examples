# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "angular-example"

app "angular" {
  build {
    use "pack" {}
  }

  deploy {
    use "docker" {
    }
  }
}
