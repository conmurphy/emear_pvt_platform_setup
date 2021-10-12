variable "github_token" {}
variable "tfcb_token" {}
variable "oauth_token_id" {}
variable "tfe_organization_name" {}
variable "tfe_agent_pool_name" {
    default = "emearpvt"
}

variable "tfe_workspace_auto_approve"{
    default = true
}
variable "tfe_workspace_terraform_version"{
    default = "1.0.3"
}

locals {
    github_visibility = "public"
    github_template_owner = "conmurphy"
    github_template_repository_name = "emear_pvt_application_template"
    github_sentinel_policy = "conmurphy/demo-sentinel-policies"

}