terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    
  }
}

provider "azuread" {
  
}

data "azurerm_client_config" "current" {
  
}