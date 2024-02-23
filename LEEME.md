```bash
pwsh
```

```powershell
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {Install-Module -Name $_ -AllowPrerelease}
```

Connect to Azure

```powershell
Connect-AzAccount
```

Install these modules to support the Azure Image Builder service.

```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
Import-Module Az.Resources
```

```powershell
# Get existing context 
$currentAzContext = Get-AzContext

# Get your current subscription ID  
$subscriptionID=$currentAzContext.Subscription.Id

# Destination image resource group  
$imageResourceGroup="DevBoxDemos"

# Location  
$location="westeurope"

# Image distribution metadata reference name  
$runOutputName="aibCustWinManImg01"

# Image template name  
$imageTemplateName="vscodeWinTemplate"
```

VM Image Builder uses the provided user identity to inject the image into Azure Compute Gallery.

```powershell
# Set up role definition names, which need to be unique 
$timeInt=$(get-date -UFormat "%s") 
$imageRoleDefName="Azure Image Builder Image Def"+$timeInt 
$identityName="aibIdentity"+$timeInt 

# Add an Azure PowerShell module to support AzUserAssignedIdentity 
Install-Module -Name Az.ManagedServiceIdentity 

# Create an identity 
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location

$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id 
$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId
```
Assign permissions for the identity to distribute the images.

```powershell
$aibRoleImageCreationUrl="https://raw.githubusercontent.com/azure/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json" 
$aibRoleImageCreationPath = "aibRoleImageCreation.json" 

# Download the configuration 
Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $aibRoleImageCreationPath 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $aibRoleImageCreationPath 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath 

# Create a role definition 
New-AzRoleDefinition -InputFile  ./aibRoleImageCreation.json

# Grant the role definition to the VM Image Builder service principal 
New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName "Azure Image Builder Service Image Creation Role" -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"
```

Create the gallery

```powershell
# Gallery name 
$galleryName= "devboxGallery" 

# Image definition name 
$imageDefName ="vscodeImageDef" 

# Additional replication region 
$replRegion2="eastus" 

# Create the gallery 
New-AzGallery -GalleryName $galleryName -ResourceGroupName $imageResourceGroup -Location $location 

$SecurityType = @{Name='SecurityType';Value='TrustedLaunch'} 
$features = @($SecurityType) 

# Create the image definition
New-AzGalleryImageDefinition -GalleryName $galleryName -ResourceGroupName $imageResourceGroup -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher 'myCompany' -Offer 'vscodebox' -Sku '1-0-0' -Feature $features -HyperVGeneration "V2"
```

```powershell
$templateFilePath = 'custom-images/pw-example.json'

(Get-Content -path $templateFilePath -Raw ) -replace '<subscriptionID>',$subscriptionID | Set-Content -Path $templateFilePath 
(Get-Content -path $templateFilePath -Raw ) -replace '<rgName>',$imageResourceGroup | Set-Content -Path $templateFilePath 
(Get-Content -path $templateFilePath -Raw ) -replace '<runOutputName>',$runOutputName | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<imageDefName>',$imageDefName | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<sharedImageGalName>',$galleryName| Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<region1>',$location | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<region2>',$replRegion2 | Set-Content -Path $templateFilePath  
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$identityNameResourceId) | Set-Content -Path $templateFilePath
```

```powershell
New-AzResourceGroupDeployment  -ResourceGroupName $imageResourceGroup  -TemplateFile $templateFilePath  -Api-Version "2020-02-14"  -imageTemplateName $imageTemplateName  -svclocation $location
```

Build the image by invoking the Run command on the template:

```powershell
Invoke-AzResourceAction  -ResourceName $imageTemplateName  -ResourceGroupName $imageResourceGroup  -ResourceType Microsoft.VirtualMachineImages/imageTemplates  -ApiVersion "2020-02-14"  -Action Run
```

```powershell
Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup | Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState
```