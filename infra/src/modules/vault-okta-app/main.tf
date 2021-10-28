resource "okta_app_oauth" "main" {
  label          = var.name
  type           = "web"
  grant_types    = ["authorization_code"]
  redirect_uris  = ["${var.vault_addr}/ui/vault/auth/${var.vault_okta_backend_path}/oidc/callback"]
  response_types = ["code"]
  groups_claim {
    type        = "FILTER"
    filter_type = "EQUALS"
    name        = "groups"
    value       = var.group_name
  }
  lifecycle {
    ignore_changes = [groups]
  }
}

resource "okta_app_oauth_api_scope" "default" {
  app_id = okta_app_oauth.main.id
  issuer = var.issuer
  scopes = ["okta.groups.read", "okta.users.read.self"]
}

resource "okta_group" "main" {
  name        = var.group_name
  description = var.group_name
  skip_users  = true
}

resource "okta_app_group_assignment" "main" {
  app_id   = okta_app_oauth.main.id
  group_id = okta_group.main.id
}
