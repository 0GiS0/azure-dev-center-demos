# 🚀 Microsoft Dev Box 💻 & Azure Deployment Environments 🏗️ Demos for Platform Engineering

👋🏻 Welcome, developer! This repository contains scripts and resources to help you understand how Microsoft Dev Box and Azure Deployment Environments work.

## 📑 Table of Contents

- [🛠️ Prerequisites](#prerequisites)
- [🚦 Getting Started](#getting-started)
- [⚙️ Setup Options](#setup-options)
  - [📦 Minimal Setup](#minimal-setup)
  - [🖥️ Basic Dev Box Setup](#basic-dev-box-setup)
  - [🖼️ Custom Image Creation](#custom-image-creation)
  - [👩🏼‍💻 Individual Customization](#individual-customization)
  - [👩🏽‍🤝‍👨🏾 Team Customizations](#team-customizations)
  - [🌐 Network Integration](#network-integration)
  - [☁️ Azure Deployment Environments](#azure-deployment-environments)
  - [📊 Usage Monitoring](#usage-monitoring)
- [🧹 Clean Up](#clean-up)

---

## 🛠️ <a name="prerequisites"></a>Prerequisites

This repo use [Dev Containers extension with Visual Studio Code](https://marketplace.visualstudio.com/items/?itemName=ms-vscode-remote.remote-containers) to get all required tools pre-installed.

If you don't want to use Dev Containers, you can install the following tools manually 😅:

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [jq](https://stedolan.github.io/jq/)
- [Git](https://git-scm.com/)
- [Terraform](https://www.terraform.io/downloads.html)
- [Packer](https://developer.hashicorp.com/packer/downloads)
- [Azure Dev Center CLI](https://learn.microsoft.com/en-us/cli/azure/devcenter?view=azure-cli-latest)
- [Gum](https://github.com/charmbracelet/gum)

**Important:** You will also need a `.env` file with a personal access token (PAT) to read GitHub repo contents.
- Create a `.env` file by copying the `.env-sample`.
- Populate it with your GitHub PAT. See [GitHub documentation on creating a PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) if you need help.

---

## 🚦 <a name="getting-started"></a>Getting Started

### 1. Install Azure Dev Center Extension 🧩

```bash
az extension add --name devcenter
```

### 2. Log in to Your Azure Subscription

```bash
az login --use-device-code
```

### 3. Set Environment Variables

[View Script: 00-variables-and-registrations.sh](scripts/00-minimal-setup/00-variables-and-registrations.sh)
```bash
source scripts/00-minimal-setup/00-variables-and-registrations.sh
```

---

## ⚙️ <a name="setup-options"></a>Setup Options

## 📦 <a name="minimal-setup"></a>Minimal Setup: Resource Group 📦, Dev Center 🏢, and Projects 👷🏼‍♀️👷🏻‍♂️

#### Create a Resource Group 📦

[View Script: 01-create-rg.sh](scripts/00-minimal-setup/01-create-rg.sh)
```bash
source scripts/00-minimal-setup/01-create-rg.sh
```

#### Create a Dev Center 🏢

[View Script: 02-create-dev-center.sh](scripts/00-minimal-setup/02-create-dev-center.sh)
```bash
source scripts/00-minimal-setup/02-create-dev-center.sh
```

#### Create Projects and Entra ID Groups

Dev Center uses Microsoft Entra ID groups to manage access to projects. You can create a group (or use existing ones) for developers and assign them to the project.

Create a Microsoft Entra ID Group for your developers:

[View Script: 03-create-entra-id-groups.sh](scripts/00-minimal-setup/03-create-entra-id-groups.sh)
```bash
source scripts/00-minimal-setup/03-create-entra-id-groups.sh
```

Create projects:

[View Script: 03-create-projects.sh](scripts/00-minimal-setup/03-create-projects.sh)
```bash
source scripts/00-minimal-setup/03-create-projects.sh
```

---

## 🖥️ <a name="basic-dev-box-setup"></a>Basic Setup: Create a Dev Box from Azure Marketplace Image 🖥️

#### Create a Dev Box Definition 📦

[View Script: 01-create-dev-box-definition.sh](scripts/01-basic-devbox/01-create-dev-box-definition.sh)
```bash
source scripts/01-basic-devbox/01-create-dev-box-definition.sh
```

#### Create a Dev Box Pool

[View Script: 02-create-dev-box-pool.sh](scripts/01-basic-devbox/02-create-dev-box-pool.sh)
```bash
source scripts/01-basic-devbox/02-create-dev-box-pool.sh
```

#### Access the Developer Portal

Congrats 🎉! Access the [Developer Portal](https://devportal.microsoft.com) and create a new dev box using any user in the Devs group 👩🏼‍💻👨🏻‍💻.

---

## 🖼️ <a name="custom-image-creation"></a>Create a Custom Image 🖼️

### Option 1: Azure Image Builder

#### 1. Create a Gallery 🖼

[View Script: 01-create-azure-compute-gallery.sh](scripts/02-custom-devbox/image-builder/01-create-azure-compute-gallery.sh)
```bash
source scripts/02-custom-devbox/image-builder/01-create-azure-compute-gallery.sh
```

#### 2. Create Image Definition ✏

[View Script: 02-create-image-definition.sh](scripts/02-custom-devbox/image-builder/02-create-image-definition.sh)
```bash
source scripts/02-custom-devbox/image-builder/02-create-image-definition.sh
```

#### 3. Create Image Version 🏞️

Set up identity and custom role for Image Builder:

[View Script: 03-create-azure-image-builder-identity-and-role.sh](scripts/02-custom-devbox/image-builder/03-create-azure-image-builder-identity-and-role.sh)
```bash
source scripts/02-custom-devbox/image-builder/03-create-azure-image-builder-identity-and-role.sh
```

Define your image template (e.g., `custom-images/win11-with-vscode.json`):

[View Script: 04-create-an-image-template.sh](scripts/02-custom-devbox/image-builder/04-create-an-image-template.sh)
```bash
source scripts/02-custom-devbox/image-builder/04-create-an-image-template.sh
```

#### 4. Use the Custom Image

[View Script: 05-create-dev-box-definition.sh](scripts/02-custom-devbox/image-builder/05-create-dev-box-definition.sh)
```bash
source scripts/02-custom-devbox/image-builder/05-create-dev-box-definition.sh
```

[View Script: 06-create-dev-box-pool.sh](scripts/02-custom-devbox/image-builder/06-create-dev-box-pool.sh)
```bash
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

[View Script: 01-create-resources-using-tf.sh](scripts/02-custom-devbox/packer/01-create-resources-using-tf.sh)

```bash
source scripts/02-custom-devbox/packer/01-create-resources-using-tf.sh
```

4.Attach the gallery and create definitions/pools:

[View Script: 02-assign-packer-gallery.sh](scripts/02-custom-devbox/packer/02-assign-packer-gallery.sh)

```bash
source scripts/02-custom-devbox/packer/02-assign-packer-gallery.sh
```

[View Script: 03-create-dev-box-definitions-for-packer-images.sh](scripts/02-custom-devbox/packer/03-create-dev-box-definitions-for-packer-images.sh)

```bash
source scripts/02-custom-devbox/packer/03-create-dev-box-definitions-for-packer-images.sh
```

[View Script: 04-create-dev-box-pool-with-packer-images.sh](scripts/02-custom-devbox/packer/04-create-dev-box-pool-with-packer-images.sh)

```bash
source scripts/02-custom-devbox/packer/04-create-dev-box-pool-with-packer-images.sh
```

Check the [Developer Portal](https://devportal.microsoft.com) for your new images.

---

## 👩🏼‍💻 <a name="individual-customization"></a>Individual Customization 👩🏼‍💻

The Microsoft Dev Box customizations feature helps you streamline the setup of the developer environment. With customizations, you can configure ready-to-code workstations with the necessary applications, tools, repositories, code libraries, packages, and build scripts.

Platform admins define a Catalog of allowed tasks (YAML + script). Attach the `allowed-tasks` folder to the Dev Center:

[View Script: 00-attach-catalog-with-allowed-tasks.sh](scripts/02-custom-devbox/customizations/00-attach-catalog-with-allowed-tasks.sh)
```bash
source scripts/02-custom-devbox/customizations/00-attach-catalog-with-allowed-tasks.sh
```

Create a new dev box with customizations by uploading `devbox-customizations/workload.yaml` in the Developer Portal.

Installed example: Visual Studio Code

---

## 👩🏽‍🤝‍👨🏾 <a name="team-customizations"></a>Team Customizations 👩🏽‍🤝‍👨🏾

Team customizations are used to create a shared configuration for a team of developers. In this folder `team-customization-files` you can find the YAML files that define the team customizations.

And with this script you can attach the team customizations folder to a particular project in your dev center:

[View Script: 01-attach-project-catalog-with-team-customizations.sh](scripts/02-custom-devbox/customizations/01-attach-project-catalog-with-team-customizations.sh)
```bash
source scripts/02-custom-devbox/customizations/01-attach-project-catalog-with-team-customizations.sh
```

It will create a new pool for each team customization.

More information on [Team Customizations](https://learn.microsoft.com/en-us/azure/dev-box/concept-what-are-team-customizations?tabs=team-customizations).

---

## 🌐 <a name="network-integration"></a>Integrate Dev Box with a Virtual Network 🌐

#### Create Network Connections 📞

[View Script: 01-create-vnet-and-network-connections.sh](scripts/03-network-integration/01-create-vnet-and-network-connections.sh)
```bash
source scripts/03-network-integration/01-create-vnet-and-network-connections.sh
```

#### Create a SQL Server VM in the VNet

[View Script: 02-create-vm-with-sql-server-in-that-vnet.sh](scripts/03-network-integration/02-create-vm-with-sql-server-in-that-vnet.sh)
```bash
source scripts/03-network-integration/02-create-vm-with-sql-server-in-that-vnet.sh
```

#### Create a Dev Box Pool 🖥️

[View Script: 03-create-dev-box-pool.sh](scripts/03-network-integration/03-create-dev-box-pool.sh)
```bash
source scripts/03-network-integration/03-create-dev-box-pool.sh
```

Go to the [Developer Portal](https://devportal.microsoft.com) and create a dev box 👩🏼‍💻.

---

## ☁️ <a name="azure-deployment-environments"></a>Azure Deployment Environments ☁️

### Using ARM

An environment definition consists of:

- An ARM template (e.g., `azuredeploy.json`)
- A configuration file (`environment.yaml`)

See examples in the `catalog` folder.

[View Script: 01-create-a-catalog.sh](scripts/04-environments/01-create-a-catalog.sh)
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

---

## 📊 <a name="usage-monitoring"></a>Check Usage 📊

[View Script: 11-check-usage.sh](scripts/05-usage/11-check-usage.sh)
```bash
source scripts/05-usage/11-check-usage.sh
```

---

## 🧹 <a name="clean-up"></a>Clean Up

🎉 Congratulations! You did it! To clean up all resources:

> **Note:** Delete user-created environments before deleting resources.

[View Script: clean-up.sh](scripts/clean-up.sh)
```bash
source scripts/clean-up.sh
```
