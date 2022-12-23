output "simple_string" {
  description = "a simple string output"
  value       = "tfc_output_string"
}

output "map_of_strings" {
  description = "a map of strings"
  value       = {
    "tfc_output_key1" = "tfc_output_value1",
    "tfc_output_key2" = "tfc_output_value2"
  }
}

output "list_of_strings" {
  description = "a map of strings"
  value       = [
    "tfc_output_item_1",
    "tfc_output_item_2",
    "tfc_output_item_3"
  ]
}
