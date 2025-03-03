terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}

  skip_provider_registration = true

  subscription_id = var.ade_subscription
}

variable "ade_subscription" {}

variable "resource_name" {}

variable "location" {}

variable "resource_group_name" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_service_plan" "service_plan" {
  name                = replace(var.resource_name, " ", "-")
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = "P1v2"
  os_type             = "Linux"
}

resource "azurerm_windows_web_app" "web" {
  name                = replace(var.resource_name, " ", "-")
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {}
}
