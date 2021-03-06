
data "tfe_agent_pool" "agent_pool" {
  name          = var.tfe_agent_pool_name
  organization  = var.tfe_organization_name
}

# Create a workspace in Terraform cloud with the same name as the application
# This will connect to IKS and deploy the helm chart containing the container image/application code
resource "tfe_workspace" "tfe_workspace" {
  for_each =  toset(var.applications)
  name           = "PVT_04_APP_${each.key}" 
  organization   = var.tfe_organization_name
  execution_mode = "agent"
  agent_pool_id = data.tfe_agent_pool.agent_pool.id
  auto_apply = local.tfe_workspace_auto_approve
  terraform_version = local.tfe_workspace_terraform_version
  structured_run_output_enabled = local.structured_run_output_enabled

}

resource "tfe_variable" "tfe_variable" {
  for_each =  toset(var.applications)
  key          = "kubernetes_host"
  value        = yamldecode(base64decode(data.intersight_kubernetes_cluster.iks.results[0].kube_config)).clusters[0].cluster.server
  category     = "terraform"
  workspace_id = tfe_workspace.tfe_workspace[each.key].id

  depends_on = [tfe_workspace.tfe_workspace]

}

data "kubernetes_secret" "kubernetes_secret" {
  for_each =  toset(var.applications)
  metadata {
    name = kubernetes_service_account.kubernetes_service_account[each.key].default_secret_name
    namespace = each.key
  }

}

resource "tfe_variable" "tfe_sensitive_variable" {
  for_each =  toset(var.applications)
  key          = "kubernetes_token"
  value        = data.kubernetes_secret.kubernetes_secret[each.key].data.token
  category     = "terraform"
  workspace_id = tfe_workspace.tfe_workspace[each.key].id
  sensitive = true

}