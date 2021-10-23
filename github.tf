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

# this branch is used by the github actions workflow to upload the helm packages
resource "github_branch" "github_branch" {
    for_each = toset(var.applications)
    repository = github_repository.github_repository[each.key].name
    branch     = "gh-pages"
}

resource "github_actions_secret" "github_token" {
    for_each =  toset(var.applications)
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "GIT_TOKEN"
    encrypted_value  = var.github_token_encrypted
}

resource "github_actions_secret" "dockerhub_token" {
    for_each =  toset(var.applications)
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "DOCKERHUB_TOKEN"
    encrypted_value  = var.dockerhub_token
}

resource "github_actions_secret" "dockerhub_username" {
    for_each =  toset(var.applications)
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "DOCKERHUB_USERNAME"
    plaintext_value   = var.dockerhub_username
}

resource "github_actions_secret" "tfc_org" {
    for_each =  toset(var.applications)
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "TFC_ORG"
    plaintext_value  = var.tfe_organization_name
}

resource "github_actions_secret" "tfc_token" {
    for_each =  toset(var.applications)
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "TFC_TOKEN"
    plaintext_value  = var.tfcb_token
}

resource "github_actions_secret" "tfc_workspace" {
    for_each =  toset(var.applications) 
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "TFC_WORKSPACE"
    plaintext_value  = "PVT_04_APP_${each.key}"
}

resource "github_actions_secret" "redis_access_key" {
    for_each =  toset(var.applications)
    repository       = github_repository.github_repository[each.key].name
    secret_name      = "REDIS_ACCESS_KEY"
    encrypted_value  = var.redis_access_key
}