terraform {
  cloud {
    organization = "waypoint_tfc_vars_example" // you must change this

    workspaces {
      name = "waypoint_tfc_vars_example"
    }
  }
}