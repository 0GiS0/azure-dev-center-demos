packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "windows" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  location        = "${var.location}"


  managed_image_resource_group_name = "${var.resource_group}"
  managed_image_name                = "${var.image_name}"

  shared_image_gallery_destination {
    subscription         = "${var.subscription_id}"
    resource_group       = "${var.gallery_resource_group}"
    gallery_name         = "${var.gallery_name}"
    image_name           = "${var.image_name}"
    image_version        = "${var.image_version}"
    storage_account_type = "Standard_LRS"

    target_region {
      name = "${var.location}"
    }
  }

  os_type         = "Windows"
  vm_size         = "Standard_D8s_v3"
  image_offer     = "windows-ent-cpc"
  image_publisher = "MicrosoftWindowsDesktop"
  image_sku       = "win11-21h2-ent-cpc-m365"
  image_version   = "latest"

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "5m"
  winrm_username = "packer"
}

build {
  sources = ["source.azure-arm.windows"]
  provisioner "powershell" {
    inline = [
      # Install Eclipse with Chocolatey
      "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
      "choco install -y eclipse",      
       # Generalize the VM
      "& $env:SystemRoot\\system32\\sysprep\\sysprep.exe /oobe /generalize /quiet /quit",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}