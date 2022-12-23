project = "waypoint_tfc_vars_example"

app "waypoint_tfc_vars_example" {
  build {
    use "docker" {
    }
  }

  deploy {
    use "docker" {
      static_environment = var.all_outputs.map_of_strings

      labels = {
        "simple_string" = var.single_string_output
        "list_item"     = var.single_list_output[1]
      }
    }
  }
}

variable "single_string_output" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // replace this with your org id
    workspace    = "waypoint_tfc_vars_example" // replace if desired - this is what the tfc module will create
    output       = "simple_string"
  })
  type        = string
  sensitive   = false
  description = "Just one tfc output variable with a string type"
}

variable "single_list_output" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // replace this with your org id
    workspace    = "waypoint_tfc_vars_example" // replace if desired - this is what the tfc module will create
    output       = "list_of_strings"
  })
  type        = list(string)
  sensitive   = false
  description = "One tfc output, but with a type of list<string>"
}

variable "all_outputs" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // replace this with your org id
    workspace    = "waypoint_tfc_vars_example" // replace if desired - this is what the tfc module will create
    // output omitted - will get all outputs
  })
  type        = any
  sensitive   = false
  description = "all workspace outputs. Will be a map, with keys as the output names"
}


