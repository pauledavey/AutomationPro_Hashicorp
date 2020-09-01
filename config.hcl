storage "file" {
  path    = "/usr/local/bin/hashicorp/vault153/vaultdata"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = "true"
}

api_addr = "http://127.0.0.1:8200"
ui = true
