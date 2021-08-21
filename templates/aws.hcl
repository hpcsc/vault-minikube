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
{{- with secret "aws/sts/dynamo" -}}
{
  "accessKey": "{{.Data.access_key}}",
  "secretKey": "{{.Data.secret_key}}",
  "securityToken": "{{.Data.security_token}}"
}
{{- end -}}
EOT
  destination = "tmp/aws"
}
