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

  // YOU NEED TO EXPORT THE GITHUB TOKEN BECAUSE OF AN ERROR WITH THIS PROVIDER
  // export GITHUB_TOKEN=<insert your token>
  
  //https://github.com/integrations/terraform-provider-github/issues/830

  token = var.github_token
}
