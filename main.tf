variable "applications" {
  type = list(string)
  default = ["healthcare-test"]

}

resource "github_repository" "github_repository" {
  for_each =  toset(var.applications)

  name        = each.key
  description = "Created by Terraform TFE workflow"

  visibility = local.github_visibility

  template {
    owner      = local.github_template_owner
    repository = local.github_template_repository_name
  }
}

data "tfe_agent_pool" "agent_pool" {
  name          = var.tfe_agent_pool_name
  organization  = var.tfe_organization_name
}


# Create a workspace in Terraform cloud with the same name as the application
# This will connect to IKS and deploy the helm chart containing the container image/application code
resource "tfe_workspace" "tfe_workspace" {
  name           = each.key
  organization   = var.tfe_organization_name
  execution_mode = "agent"
  agent_pool_id = data.tfe_agent_pool.agent_pool.id
  auto_apply = var.tfe_workspace_auto_approve
  terraform_version = var.tfe_workspace_terraform_version

  vcs_repo {
    identifier = github_repository.github_repository[each.key].full_name
    oauth_token_id = var.oauth_token_id
  }
  depends_on = [github_repository.github_repository]
}

# variable "tfe_variables" {
#   type = list(string)
#   default = ["apic_username", "apic_url","tenant_name", "vrf_name", "application_profile_name"]
# }

# variable "tfe_sensitive_variables" {
#   type = list(string)
#   default = ["apic_password"]
# }

# resource "tfe_variable" "tfe_variable" {
#   for_each = toset(var.tfe_variables)
#   key          = each.key
#   value        = each.key
#   category     = "terraform"
#   workspace_id = tfe_workspace.tfe_workspace.id
# }

# resource "tfe_variable" "tfe_sensitive_variable" {
#   for_each = toset(var.tfe_sensitive_variables)
#   key          = each.key
#   value        = each.key
#   category     = "terraform"
#   workspace_id = tfe_workspace.tfe_workspace.id
#   sensitive = true
# }