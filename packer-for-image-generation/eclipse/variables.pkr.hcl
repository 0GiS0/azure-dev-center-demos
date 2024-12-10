variable "client_id" {
  type = string
    default = "${env("ARM_CLIENT_ID")}"
}
variable "client_secret" {
  type = string
    default = "${env("ARM_CLIENT_SECRET")}"
}
variable "subscription_id" {
  type = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}
variable "tenant_id" {
  type = string
  default = "${env("ARM_TENANT_ID")}"
}
variable "resource_group" {
  type    = string
  default = "${env("ARM_RESOURCE_GROUP_NAME")}"
}
variable "location" {
  type    = string
  default = "northeurope"
}

variable "image_name" {
  type    = string
  default = "eclipse"
}

variable "gallery_resource_group" {
  type    = string
  default = "packer-rg"
}

variable "gallery_name" {
  type    = string
  default = "packer_gallery"
}

variable "image_version" {
  type    = string
  default = "1.0.0"
}

variable "build_resource_group_name" {
  type    = string
}