source "azure-arm" "windows" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  location                          = "${var.location}"
  managed_image_resource_group_name = "${var.resource_group}"
  managed_image_name                = "WinSrvWithIIS"
  os_type                           = "Windows"
  vm_size = "Standard_DS1_v2"
  image_offer     = "WindowsServer"
  image_publisher = "MicrosoftWindowsServer"
  image_sku       = "2022-datacenter-azure-edition"
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
      # Install IIS with PowerShell
      "Install-WindowsFeature -name Web-Server -IncludeManagementTools",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}
