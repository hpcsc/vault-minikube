resource "okta_auth_server" "main" {
  audiences   = ["api://vault-minikube"]
  description = "vault minikube"
  name        = "vault-minikube"
  issuer_mode = "CUSTOM_URL"
  status      = "ACTIVE"
}

resource "okta_auth_server_claim" "default" {
  auth_server_id          = okta_auth_server.main.id
  name                    = "groups"
  always_include_in_token = true
  value_type              = "GROUPS"
  group_filter_type       = "STARTS_WITH"
  value                   = "vault_"
  scopes                  = ["profile"]
  claim_type              = "IDENTITY"
}

resource "okta_auth_server_policy" "default" {
  auth_server_id   = okta_auth_server.main.id
  status           = "ACTIVE"
  name             = "default"
  description      = "default"
  priority         = 1
  client_whitelist = ["ALL_CLIENTS"]
}

resource "okta_auth_server_policy_rule" "default" {
  auth_server_id       = okta_auth_server.main.id
  policy_id            = okta_auth_server_policy.default.id
  status               = "ACTIVE"
  name                 = "default"
  priority             = 1
  group_whitelist      = ["EVERYONE"]
  grant_type_whitelist = ["authorization_code", "implicit"]
  scope_whitelist      = ["*"]
}
