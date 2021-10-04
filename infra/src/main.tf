module "okta_auth_server" {
  source = "./modules/okta-auth-server"

  name        = "vault-minikube"
  description = "Auth server for vault minikube"
  audiences   = ["api://vault-minikube"]
}
