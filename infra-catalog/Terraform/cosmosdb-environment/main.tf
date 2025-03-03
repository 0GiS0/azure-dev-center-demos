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

  subscription_id = var.ade_subscription

}

variable "ade_subscription" {}

variable "resource_name" {}

variable "location" {}

variable "cosmosdb_offer_type" {
  default = "Standard"
}

variable "cosmosdb_kind" {
  default = "MongoDB"
}

variable "cosmosdb_consistency_level" {
  default = "BoundedStaleness"
}

variable "cosmosdb_max_interval_in_seconds" {
  default = 300
}

variable "cosmosdb_max_staleness_prefix" {
  default = 100000
}

variable "resource_group_name" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

variable "cosmosdb_geo_locations" {
  type = list(object({
    location          = string
    failover_priority = number
  }))
  default = [
    { location = "northeurope", failover_priority = 1 },
    { location = "spaincentral", failover_priority = 0 }
  ]
}


resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-db-${random_integer.ri.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = var.cosmosdb_offer_type
  kind                = var.cosmosdb_kind

  automatic_failover_enabled = true

  consistency_policy {
    consistency_level       = var.cosmosdb_consistency_level
    max_interval_in_seconds = var.cosmosdb_max_interval_in_seconds
    max_staleness_prefix    = var.cosmosdb_max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = var.cosmosdb_geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
    }
  }
}
