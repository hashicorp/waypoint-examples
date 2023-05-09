resource "github_repository" "templated_app_repository" {
  name = var.repo_name

  visibility = "public"

  template {
    owner                = var.github_org_name
    repository           = var.template_repo_name
    include_all_branches = true
  }

  provisioner "local-exec" {
    command     = "./scripts/render-repo.sh"
    interpreter = ["bash"]
    environment = {
      WAYPOINT_PROJECT_NAME = var.repo_name
      GITHUB_TOKEN          = var.github_token
      OWNER                 = var.github_org_name
    }
  }
}