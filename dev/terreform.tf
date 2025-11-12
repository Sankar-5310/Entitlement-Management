terraform {
  required_version = ">=1.4.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
    msgraph = {
      source  = "microsoft/msgraph"
      version = ">=0.2.0"
    }
  }
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

provider "msgraph" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}