variable "applications" {
  type = list(string)
  default = ["healthcare-test"]

}

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

# data "tfe_agent_pool" "agent_pool" {
#   name          = var.tfe_agent_pool_name
#   organization  = var.tfe_organization_name
# }


# # Create a workspace in Terraform cloud with the same name as the application
# # This will connect to IKS and deploy the helm chart containing the container image/application code
# resource "tfe_workspace" "tfe_workspace" {
#   for_each =  toset(var.applications)
#   name           = each.key
#   organization   = var.tfe_organization_name
#   execution_mode = "agent"
#   agent_pool_id = data.tfe_agent_pool.agent_pool.id
#   auto_apply = local.tfe_workspace_auto_approve
#   terraform_version = local.tfe_workspace_terraform_version
#   structured_run_output_enabled = local.structured_run_output_enabled

#   # vcs_repo {
#   #   identifier = github_repository.github_repository[each.key].full_name
#   #   oauth_token_id = var.oauth_token_id
#   # }
#   depends_on = [github_repository.github_repository]
# }

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

resource "kubernetes_service_account" "kubernetes_service_account" {
  for_each =  toset(var.applications)

  metadata {
    name = each.key
  }
  secret {
    name = "${kubernetes_secret.kubernetes_secret.metadata.0.name}"
    namespace = each.key
  }
}

resource "kubernetes_secret" "kubernetes_secret" {
  for_each =  toset(var.applications)

  metadata {
    name = each.key
    namespace = each.key
  }
}

resource "kubernetes_namespace" "kubernetes_namespace" {
  for_each =  toset(var.applications)
  metadata {
     name = each.key
  }
}

resource "kubernetes_role" "role" {
  for_each =  toset(var.applications)

  metadata {
    name = each.key
    namespace = each.key
  }

  rule {
    api_groups     = ["*"]
    resources      = ["namespaces","pods","pods/*","pods/exec","pods/logs","pods/log","persistentvolumes","persistentvolumeclaims","configmaps","secrets","replicasets","deployments","deployments/scale","daemonsets","statefulsets","jobs","cronjobs", "services", "replicationcontrollers", "horizontalpodautoscalers","ingresses"]
    verbs          = ["get","list","watch","create","update","patch","delete"]
  }
  
}

resource "kubernetes_role_binding" "role_binding" {
  for_each =  toset(var.applications)

  metadata {
    name      = each.key
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = each.key
  }
  subject {
    kind      = "ServiceAccount"
    name      = each.key
    namespace = each.key
    api_group = "rbac.authorization.k8s.io"
  }
}