terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"      
    }

    random = {
      source  = "hashicorp/random"      

    }
  }
}

provider "azurerm" {

  subscription_id = "1ec8abed-1fec-4113-b07d-4d97912e2f87"

  features {

  }
}
