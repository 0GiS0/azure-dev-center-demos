variable "resource_group" {
  description = "The Resource Group in which the Dev Center should be created"
  type= object({
    name = string
    location = string
  })
}

variable "shared_gallery_id" {
  description = "The ID of the Shared Gallery to associate with this Dev Center"
  type        = string
}

variable "identity" {
  description = "The User Assigned Identity to associate with the Dev Center"
  type        = object({
    id = string
    client_id = string
  })
}

variable "key_vault_id" {
  description = "The ID of the Key Vault to associate with this Dev Center"
  type        = string
}

variable "subnet-id" {
  description = "The Virtual Network to attach to the Dev Center"
  type        = string
}