terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.13"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.24.1"
    }
  }
}

provider "okta" {
  org_name = var.okta_org_name
  base_url = local.okta_base_url
}

provider "vault" {
}
