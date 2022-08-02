terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"

    }

    azuread = {
      source = "hashicorp/azuread"
      version = "~> 1.0"
    }
  }
}

# Azure DevOps provider configuration

provider "azuredevops" {
  org_service_url = var.org_service_url
  personal_access_token = var.pat
}

# Azurerm provider configuration
provider "azurerm" {
  features {}
}

#Configure the Azure Provider
#provider "azurerm" {
#  features {}
#  version         = ">= 2.0"
#  environment     = "public"
#  subscription_id = var.azure_subscription_id
#  client_id       = var.azure_client_id
#  client_secret   = var.azure_client_secret
#  tenant_id       = var.azure_tenant_id
#}
