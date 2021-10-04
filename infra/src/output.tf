output "okta_auth_issuer" {
  value = module.vault_minikube.issuer
}

output "okta_auth_audiences" {
  value = module.vault_minikube.audiences
}
