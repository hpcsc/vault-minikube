resource "vault_jwt_auth_backend" "main" {
  description        = "JWT auth backend for ${var.issuer}"
  path               = var.vault_okta_backend_path
  type               = "oidc"
  oidc_discovery_url = var.issuer
  bound_issuer       = var.issuer
  oidc_client_id     = var.client_id
  oidc_client_secret = var.client_secret
  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "24h"
    max_lease_ttl      = "48h"
    token_type         = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "role" {
  for_each       = { for role in var.roles : role.name => role }
  backend        = vault_jwt_auth_backend.main.path
  role_name      = each.key
  token_policies = each.value.policies

  allowed_redirect_uris = [
    "${var.vault_addr}/ui/vault/auth/${var.vault_okta_backend_path}/oidc/callback"
  ]

  user_claim      = "email"
  role_type       = "oidc"
  bound_audiences = var.bound_audiences
  oidc_scopes = [
    "openid",
    "profile",
    "email",
  ]
  bound_claims = {
    groups = join(",", each.value.bound_groups)
  }
}
