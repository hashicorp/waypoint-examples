# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  cloud {
    organization = "waypoint_tfc_vars_example" // you must change this

    workspaces {
      name = "waypoint_tfc_vars_example"
    }
  }
}