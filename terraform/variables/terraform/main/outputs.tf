output "simple_string" {
  description = "a simple string output"
  value       = "justastring"
}

output "map_of_strings" {
  description = "a map of strings"
  value       = {
    "key1" = "value1",
    "key2" = "value2"
  }
}

output "list_of_strings" {
  description = "a map of strings"
  value       = [
    "item_1",
    "item_2",
    "item_3"
  ]
}
