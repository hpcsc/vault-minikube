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
{{- with secret "secret/data/read-only/test-secret" -}}
{{$first := true}}
{
{{- range $key, $value := .Data.data -}}
  {{ if $first }} {{$first = false}} {{- else -}} , {{end}}
  "{{$key}}": "{{$value}}"
{{- end}}
}
{{- end -}}
EOT
  destination = "tmp/test-secret"
}
