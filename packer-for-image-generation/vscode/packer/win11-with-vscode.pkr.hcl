packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

locals{
  image_name = "VSCodeWithPacker"  
  gallery_resource_group = "packer-rg"
  gallery_name = "packer_gallery"
}

source "azure-arm" "windows" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  location                          = "${var.location}"
  
  
  managed_image_resource_group_name = "${var.resource_group}"  
  managed_image_name                = "VSCodeWithPacker"

  shared_image_gallery_destination {
    subscription = "${var.subscription_id}"
    resource_group = local.gallery_resource_group
    gallery_name = local.gallery_name
    image_name = local.image_name
    image_version = "1.0.0"
    storage_account_type = "Standard_LRS"
    
    target_region {
      name = "westeurope"
    }    
  }

  os_type                           = "Windows"
  vm_size = "Standard_DS2_v2"
  image_offer     = "Windows-11"
  image_publisher = "MicrosoftWindowsDesktop"
  image_sku       = "win11-21h2-avd"
  image_version   = "latest"

  communicator   = "winrm"
  winrm_use_ssl  = "true"
  winrm_insecure = "true"
  winrm_timeout  = "3m"
  winrm_username = "packer"
}

build {
  sources = ["source.azure-arm.windows"]
  provisioner "powershell" {
    inline = [
      # Install VS Code with Chocolatey
      "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
      "choco install -y vscode"
    ]
  }  
}