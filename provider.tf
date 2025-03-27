provider "aws" {
  region = "us-east-1"
}


provider "vault" {
  address = "http://vault-internal.salman06.shop:8200"
  token = var.vault_token
}
