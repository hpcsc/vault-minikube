exit_after_auth = true

auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes/minikube"
    config     = {
      role       = "read-only"
      token_path = "tmp/token"
    }
  }
  sink "file" {
    config = {
      path = "tmp/.vault-token"
    }
  }
}

template_config {
  exit_on_retry_failure = true
}

template {
  error_on_missing_key = true
  contents = <<EOT
{{- with secret "pki/issue/vault-minikube" "common_name=www.vault-minikube.com" -}}
{
  "expiration": "{{.Data.expiration}}",
  "private_key": "{{.Data.private_key}}",
  "private_key_type": "{{.Data.private_key_type}}",
  "serial_number": "{{.Data.serial_number}}"
}
{{- end -}}
EOT
  destination = "tmp/pki/metadata.json"
}

template {
  error_on_missing_key = true
  contents = <<EOT
{{- with secret "pki/issue/vault-minikube" "common_name=www.vault-minikube.com" -}}
{{.Data.certificate}}
{{- end -}}
EOT
  destination = "tmp/pki/vault-minikube.crt"
}

template {
  error_on_missing_key = true
  contents = <<EOT
{{- with secret "pki/issue/vault-minikube" "common_name=www.vault-minikube.com" -}}
{{.Data.private_key}}
{{- end -}}
EOT
  destination = "tmp/pki/vault-minikube.key"
}

template {
  error_on_missing_key = true
  contents = <<EOT
{{- with secret "pki/issue/vault-minikube" "common_name=www.vault-minikube.com" -}}
{{.Data.issuing_ca}}
{{- end -}}
EOT
  destination = "tmp/pki/ca.crt"
}
