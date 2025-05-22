variable "location" {
  type    = string
  default = "northeurope"
}

variable "resource_group_name" {
  type    = string
  default = "packer-rg"
}

variable "packer_image_gallery_name" {
  type    = string
  default = "packer_gallery"
}

variable "subscription_id" {
  type = string
}

variable "image_names" {
  type = map(string)
  default = {
    # vscode_with_extensions = "vscode_with_extensions"
    # secure_vscode          = "secure_vscode"
    eclipse                = "eclipse"
    jetbrains              = "jetbrains"
    # docker                 = "docker"
  }
}
