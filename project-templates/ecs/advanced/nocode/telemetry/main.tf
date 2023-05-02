resource "datadog_dashboard" "app_metrics" {
  title = var.app_name
  layout_type = "ordered"

  # the dashboard should enable toggling between dev and prod
  template_variable {
    name = "env"
    available_values = [ "dev", "prod" ]
    defaults = ["prod"]
  }

  # TODO: Dashboard widgets
}

# TODO: Monitors
