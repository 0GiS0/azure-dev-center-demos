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
    default = "${env("LOCATION")}"
}

variable "image_name" {
  type    = string
  default = "vscode"
}

variable "gallery_resource_group" {
  type    = string
  default = "${env("PACKER_GALLERY_RESOURCE_GROUP")}"
}

variable "gallery_name" {
  type    = string
  default = "${env("PACKER_GALLERY_NAME")}"
}

variable "image_version" {
  type    = string
  default = "1.0.0"
}