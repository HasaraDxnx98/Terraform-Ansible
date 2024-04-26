terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = "~>2.24.0"
  }
}

provider "azurerm" {
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
  features {}
}