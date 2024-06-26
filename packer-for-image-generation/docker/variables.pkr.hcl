variable "client_id" {
  type = string
  #   default = "${env("ARM_CLIENT_ID")}"
  default = "5cb59efc-01fa-4d67-8c4d-4a14111f163b"
}
variable "client_secret" {
  type = string
  #   default = "${env("ARM_CLIENT_SECRET")}"
  default = "-Lv8Q~UXSUcFzV8vKArkGQoXcae5TG1GbtuUWdfO"
}
variable "subscription_id" {
  type = string
  # default = "${env("ARM_SUBSCRIPTION_ID")}"
  default = "0382396b-e763-46a7-bb62-30c63914f380"
}
variable "tenant_id" {
  type = string
  # default = "${env("ARM_TENANT_ID")}"
  default = "5b5c1a41-694c-4c26-b8c0-0e7f895e62e8"
}
variable "resource_group" {
  type    = string
  # default = "${env("ARM_RESOURCE_GROUP_NAME")}"
  default = "packer-rg"
}
variable "location" {
  type    = string
  default = "westeurope"
}

variable "image_name" {
  type    = string
  default = "docker"
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
  default = "1.0.1"
}