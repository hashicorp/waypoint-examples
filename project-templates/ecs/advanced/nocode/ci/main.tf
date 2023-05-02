resource "github_repository" "templated_app_repository" {
  name = var.repo_name

  visibility = "private"

  template {
    owner = "waypoint-testing"
    repository = "waypoint-app-template"
    include_all_branches = false
  }

  provisioner "local-exec" {
    command = "./render-repo.sh"
    interpreter = "bash"
    environment = {
      WAYPOINT_PROJECT_NAME = var.repo_name
    }
  }
}