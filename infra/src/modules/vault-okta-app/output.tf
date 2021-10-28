output "client_id" {
  value     = okta_app_oauth.main.client_id
  sensitive = true
}

output "client_secret" {
  value     = okta_app_oauth.main.client_secret
  sensitive = true
}
