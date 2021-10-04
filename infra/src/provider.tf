terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.13"
    }
  }
}

provider "okta" {
  org_name = "dev-25816939"
  base_url = "okta.com"
}
