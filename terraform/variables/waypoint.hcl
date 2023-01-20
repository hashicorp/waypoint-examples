project = "waypoint_tfc_vars_example"

app "waypoint_tfc_vars_example" {
  build {
    use "docker" {
    }
  }

  deploy {
    use "docker" {

      labels = {
        // `simple_string_output` matches the terraform output `simple_string`
        "simple_string" = var.single_string_output

        // `single_list_output` matches the terraform output `list_of_strings`.
        // Note that the output is a list type in terraform, and can also be
        // treated as a list here in the waypoint hcl.
        "list_item"     = var.single_list_output[1]
      }

      // This shows referencing one variable after reading in all terraform outputs.
      // the waypoint variable is `all_outputs`, and the tfc output name is `map_of_strings`
      // (see ./terraform/main/outputs.tf).
      // Also note that the expected type for `static_environment` is also a map of strings,
      // so we can use the whole variable here. With this setting, the container will have
      // environment variables for each k/v pair in `map_of_strings`.
      static_environment = var.all_outputs.map_of_strings
    }
  }
}

# Waypoint can read string-type terraform outputs, and make them available as
# a string variable. This is the simplest way of reading from terraform.
variable "single_string_output" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // replace this with your org id
    workspace    = "waypoint_tfc_vars_example"
    output       = "simple_string"
  })
  type        = string
  sensitive   = false
  description = "Just one tfc output variable with a string type"
}

# Waypoint can also read terraform outputs with complex types that can be represented
# as json. This can be useful for reading, for example, a complete list of subnets, rather
# than needing to redeclare each subnet as its own individual string output in terraform.
variable "single_list_output" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // replace this with your org id
    workspace    = "waypoint_tfc_vars_example"
    output       = "list_of_strings"
  })
  type        = list(string)
  sensitive   = false
  description = "One tfc output, but with a type of list<string>"
}

# If many variables need to be read from terraform cloud, they can all be made available
# as a map, where the keys are the output names. This avoids many near-duplicate
# variable stanzas.
variable "all_outputs" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // replace this with your org id
    workspace    = "waypoint_tfc_vars_example"
    // output omitted - will get all outputs
  })
  type        = any
  sensitive   = false
  description = "all workspace outputs. Will be a map, with keys as the output names"
}


