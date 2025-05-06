# 🚀 Microsoft Dev Box 💻 & Azure Deployment Environments 🏗️ Demos for Platform Engineering

👋🏻 Welcome, developer! This repository contains scripts and resources to help you understand how Microsoft Dev Box and Azure Deployment Environments work.

---

## 🛠️ Prerequisites

To follow this tutorial, ensure you have the following:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

Alternatively, you can use [Dev Containers extension with Visual Studio Code](https://marketplace.visualstudio.com/items/?itemName=ms-vscode-remote.remote-containers). Just open this repo in a container to get all required tools pre-installed.

You will also need a `.env` file with a personal access token to read GitHub repo contents. See `.env-sample` for the expected format.

---

## 🚦 Getting Started

### 1. Install Azure Dev Center Extension 🧩

```bash
az extension add --name devcenter
```

### 2. Log in to Your Azure Subscription

```bash
az login --use-device-code
```

### 3. Set Environment Variables

```bash
source scripts/00-minimal-setup/00-variables-and-registrations.sh
```

---

<details>
<summary><strong>Minimal Setup: Resource Group 📦, Dev Center 🏢, and Projects 👷🏼‍♀️👷🏻‍♂️</strong></summary>

#### Create a Resource Group 📦

```bash
source scripts/00-minimal-setup/01-create-rg.sh
```

#### Create a Dev Center 🏢

```bash
source scripts/00-minimal-setup/02-create-dev-center.sh
```

#### Create Projects and Entra ID Groups

Create a Microsoft Entra ID Group for your developers:

```bash
source scripts/00-minimal-setup/03-create-entra-id-groups.sh
```

Create projects:

```bash
source scripts/00-minimal-setup/03-create-projects.sh
```

</details>

---

<details>
<summary><strong>Basic Setup: Create a Dev Box from Azure Marketplace Image 🖥️</strong></summary>

#### Create a Dev Box Definition 📦

```bash
source scripts/01-basic-devbox/01-create-dev-box-definition.sh
```

#### Create a Dev Box Pool

```bash
source scripts/01-basic-devbox/02-create-dev-box-pool.sh
```

#### Access the Developer Portal

Congrats 🎉! Access the [Developer Portal](https://devportal.microsoft.com) and create a new dev box using any user in the Devs group 👩🏼‍💻👨🏻‍💻.

</details>

---

<details>
<summary><strong>Create a Custom Image 🖼️</strong></summary>

### Option 1: Azure Image Builder

#### 1. Create a Gallery 🖼

```bash
source scripts/02-custom-devbox/image-builder/01-create-azure-compute-gallery.sh
```

#### 2. Create Image Definition ✏

```bash
source scripts/02-custom-devbox/image-builder/02-create-image-definition.sh
```

#### 3. Create Image Version 🏞️

Set up identity and custom role for Image Builder:

```bash
source scripts/02-custom-devbox/image-builder/03-create-azure-image-builder-identity-and-role.sh
```

Define your image template (e.g., `custom-images/win11-with-vscode.json`):

```bash
source scripts/02-custom-devbox/image-builder/04-create-an-image-template.sh
```

#### 4. Use the Custom Image

```bash
source scripts/02-custom-devbox/image-builder/05-create-dev-box-definition.sh
source scripts/02-custom-devbox/image-builder/06-create-dev-box-pool.sh
```

Access the [Developer Portal](https://devportal.microsoft.com) to create a dev box with your custom image.

---

### Option 2: Packer

1. [Install Packer](https://developer.hashicorp.com/packer/install?product_intent=packer).
2. Create a service principal:

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
RESULT=$(az ad sp create-for-rbac --name hcp-packer --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID)
```

Set environment variables:

```bash
export ARM_CLIENT_SECRET=$(echo $RESULT | jq -r .password)
export ARM_CLIENT_ID=$(echo $RESULT | jq -r .appId)
export ARM_TENANT_ID=$(az account show --query tenantId -o tsv)
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
export ARM_RESOURCE_GROUP_NAME=$PACKER_GALLERY_RESOURCE_GROUP
```

> **IMPORTANT:** Update `variables.pkr.hcl` with your own values.

3. Create resources using Terraform:

```bash
source scripts/02-custom-devbox/packer/01-create-resources-using-tf.sh
```

4. Attach the gallery and create definitions/pools:

```bash
source scripts/02-custom-devbox/packer/02-assign-packer-gallery.sh
source scripts/02-custom-devbox/packer/03-create-dev-box-definitions-for-packer-images.sh
source scripts/02-custom-devbox/packer/04-create-dev-box-pool-with-packer-images.sh
```

Check the [Developer Portal](https://devportal.microsoft.com) for your new images.

</details>

---

<details>
<summary><strong>Configuration-as-Code Customization ⚙️</strong></summary>

You can use configuration-as-code (YAML) to customize dev boxes by installing software, configuring settings, and running scripts.

Platform admins define a Catalog of allowed tasks (YAML + script). Attach the `allowed-tasks` folder to the Dev Center:

```bash
source scripts/02-custom-devbox/customizations/00-attach-catalog-with-allowed-tasks.sh
```

Create a new dev box with customizations by uploading `devbox-customizations/workload.yaml` in the Developer Portal.

Installed example: Visual Studio Code

</details>

---

<details>
<summary><strong>Integrate Dev Box with a Virtual Network 🌐</strong></summary>

#### Create Network Connections 📞

```bash
source scripts/03-network-integration/01-create-vnet-and-network-connections.sh
```

#### Create a SQL Server VM in the VNet

```bash
source scripts/03-network-integration/02-create-vm-with-sql-server-in-that-vnet.sh
```

#### Create a Dev Box Pool 🖥️

```bash
source scripts/03-network-integration/03-create-dev-box-pool.sh
```

Go to the [Developer Portal](https://devportal.microsoft.com) and create a dev box 👩🏼‍💻.

</details>

---

<details>
<summary><strong>Azure Deployment Environments ☁️</strong></summary>

### Using ARM

An environment definition consists of:

- An ARM template (e.g., `azuredeploy.json`)
- A configuration file (`environment.yaml`)

See examples in the `catalog` folder.

```bash
source scripts/04-environments/01-create-a-catalog.sh
```

#### Define Environments with Bicep

```bash
az bicep build --file {bicep_file} --outfile {out_file}
# Example:
az bicep build --file catalog/ARMTemplates/tour-of-heroes-environment/main.bicep --outfile catalog/ARMTemplates/tour-of-heroes-environment/azuredeploy.json
```

#### ADE Extensibility Model

You can use Bicep, Terraform, or Pulumi templates. For Terraform, **do not create the resource group** in your files:

```terraform
variable "resource_group_name" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
```

The resource group is created by Dev Center.

#### Check Deployment Logs

```bash
az devcenter dev environment list --project $PROJECT_FOR_ENVIRONMENTS --dev-center $DEV_CENTER_NAME
az devcenter dev environment show --environment-name $DEV_ENVIRONMENT_TYPE --project $PROJECT_FOR_ENVIRONMENTS --dev-center $DEV_CENTER_NAME
```

Get operation logs:

```bash
YOUR_ENVIRONMENT_NAME="direwolvescosmos"
OPERATION_ID=$(az devcenter dev environment list-operation \
  --environment-name $YOUR_ENVIRONMENT_NAME \
  --project $PROJECT_FOR_ENVIRONMENTS \
  --dev-center $DEV_CENTER_NAME \
  --query "[-1].operationId" -o tsv)

watch az devcenter dev environment show-logs-by-operation \
  --environment-name $YOUR_ENVIRONMENT_NAME \
  --project $PROJECT_FOR_ENVIRONMENTS \
  --operation-id $OPERATION_ID \
  --dev-center $DEV_CENTER_NAME
```

Delete an environment:

```bash
az devcenter dev environment delete \
  --environment-name direwolvesweb \
  --project $PROJECT_FOR_ENVIRONMENTS \
  --dev-center $DEV_CENTER_NAME
```

</details>

---

<details>
<summary><strong>Check Usage 📊</strong></summary>

```bash
source scripts/05-usage/11-check-usage.sh
```

</details>

---

## 🧹 Clean Up

🎉 Congratulations! You did it! To clean up all resources:

> **Note:** Delete user-created environments before deleting resources.

```bash
source scripts/clean-up.sh
```
