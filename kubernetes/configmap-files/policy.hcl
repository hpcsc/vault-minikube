path "secret/data/read-only/*" {
    capabilities = ["read", "list"]
}

path "aws/sts/*" {
    capabilities = ["read", "list"]
}
