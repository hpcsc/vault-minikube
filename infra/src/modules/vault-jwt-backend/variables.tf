variable "vault_addr" {
  type = string
}

variable "vault_okta_backend_path" {
  type = string
}

variable "issuer" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "bound_audiences" {
  type = list(string)
}

variable "roles" {
  type = list(object({
    name         = string
    policies     = list(string)
    bound_groups = list(string)
  }))
}
