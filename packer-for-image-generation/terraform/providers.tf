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

  subscription_id = "${var.subscription_id}"
  
  features {

  }
}
