terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.26.1"
    }
    github = {
      source = "integrations/github"
      version = "4.12.2"
    }
  }
}

provider "tfe" {
  token    = var.tfcb_token
}

provider "github" {
  token = var.github_token
}
provider "kubernetes" {
  host = var.kubernetes_host
  token = var.kubernetes_token
  insecure="true"
}
