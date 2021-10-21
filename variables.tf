
variable "iks_cluster_name" {
  type        = string
  description = "Name of IKS cluster"
}

variable "intersight_api_key" {
  type        = string
  description = "API Key"
}
variable "intersight_secret_key" {
  type        = string
  description = "Secret Key or file location"
}

variable "intersight_endpoint" {
  type        = string
  description = "API Endpoint URL"
  default     = "https://www.intersight.com"
}

variable "github_token" {}

variable "github_token_encrypted" {}

variable "dockerhub_token" {}
variable "dockerhub_username" {}

variable "tfcb_token" {}

variable "tfe_organization_name" {}
variable "tfe_agent_pool_name" {
    default = "emearpvt"
}

locals {
    github_visibility = "public"
    github_template_owner = "conmurphy"
    github_template_repository_name = "emear_pvt_application_template"
    github_sentinel_policy = "conmurphy/demo-sentinel-policies"
    structured_run_output_enabled = false
    tfe_workspace_auto_approve = true
    tfe_workspace_terraform_version = "1.0.8"

}