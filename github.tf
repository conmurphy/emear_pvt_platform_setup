# resource "github_repository" "github_repository" {
#   for_each =  toset(var.applications)

#   name        = each.key
#   description = "Created by Terraform TFE workflow"

#   visibility = local.github_visibility

#   template {
#     owner      = local.github_template_owner
#     repository = local.github_template_repository_name
#   }
# }
