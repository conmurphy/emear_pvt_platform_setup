variable "applications" {
  type = list(string)
}

module "emear_pvt_applications" {
  for_each =  toset(var.applications)
  source = "./modules/emear_pvt_applications"
  application_name = each.key
  oauth_token_id = var.oauth_token_id
  tfe_organization_name = var.tfe_organization_name
  tfe_agent_pool_name = var.tfe_agent_pool_name
} 