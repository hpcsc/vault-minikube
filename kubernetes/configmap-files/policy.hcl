path "secret/metadata/read-only" {
    capabilities = ["list"]
}

path "secret/data/read-only/*" {
    capabilities = ["read"]
}

path "secret/metadata/" {
    capabilities = ["list"]
}

path "aws/sts/*" {
    capabilities = ["read", "list"]
}

path "pki/issue/*" {
    capabilities = ["update"]
}
