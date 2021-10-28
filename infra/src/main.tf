module "okta_auth_server" {
  source = "./modules/okta-auth-server"

  name        = "vault-minikube"
  description = "Auth server for vault minikube"
  audiences   = ["api://vault-minikube"]
  group_name  = local.group_name
}

module "vault_okta_app" {
  source = "./modules/vault-okta-app"

  name                    = "vault-minikube"
  vault_addr              = var.vault_addr
  vault_okta_backend_path = local.vault_okta_backend_path
  issuer                  = "https://${var.okta_org_name}.${local.okta_base_url}"
  group_name              = local.group_name
}

module "okta_backend" {
  source = "./modules/vault-jwt-backend"

  vault_addr              = var.vault_addr
  vault_okta_backend_path = local.vault_okta_backend_path
  issuer                  = module.okta_auth_server.issuer
  client_id               = module.vault_okta_app.client_id
  client_secret           = module.vault_okta_app.client_secret
  bound_audiences         = concat(tolist(module.okta_auth_server.audiences), [module.vault_okta_app.client_id])
  roles = [{
    name         = "read-only"
    policies     = ["read-only"]
    bound_groups = [local.group_name]
  }]
}
