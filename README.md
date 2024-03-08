# Azure DevBox and Azure Deployments demos for a Platform Engineering culture

### Pre-requisites

In order to follow this tutorial, you need to have the following tools installed:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### Install Azure Dev Center extension 🧩

```bash
az extension add --name devcenter
```

### Set variables

To make it easier to follow this tutorial, let's set some variables.

```bash
source scripts/0-minimal-setup/00-variables-and-registrations.sh
```


### Create a Resource Group 📦 and virtual network 🕸️

As every Azure resource, the first thing you need to do is to create a resource group.
Also, in a enterprise environment, you will probably want to create a virtual network to connect your dev boxes to your corporate network.

```bash
scripts/0-minimal-setup/01-create-rg-and-vnet.sh
```

### Create a Gallery 🖼

Like the Azure Marketplace, a gallery is a repository for managing and sharing images and other resources, but you control who has access.

```bash
source scripts/02-create-azure-compute-gallery.sh
```

### Create the image definition ✏

Image definitions are created within a gallery and they carry information about the image and any requirements for using it to create VMs. This includes whether the image is Windows or Linux, release notes, and minimum and maximum memory requirements. It's a definition of a type of image.

```bash
source scripts/03-create-image-definition.sh
```

### Create image version 🏞️

An image version is what you use to create a VM when using a gallery. You can have multiple versions of an image as needed for your environment. Like a managed image, when you use an image version to create a VM, the image version is used to create new disks for the VM. Image versions can be used multiple times.

In order to create your custom image you can use Azure Image Builder and for that you need a identity. This identity needs some permissions but there is no built-in role. So let's create a custom role for the image builder too.

```bash
source scripts/04-create-azure-image-builder-and-role.sh
```

Lastly you need to define the ingredients for your new image: what is the image base, if some customization is needed and how much time it has the builder to build it.

We are going to use this template: `custom-images/win11-with-vscode.json` which install Visual Studio Code in a Windows 11.

```bash
source scripts/05-create-an-image-template.sh
```

And now just wait... a little bit ⌚

### Create image template with Packer

The other option to create a custom image is to use Packer. Packer is a tool for creating identical machine images for multiple platforms from a single source configuration. 

The first thing you need to do is to [install Packer](https://developer.hashicorp.com/packer/install?product_intent=packer). Once you have Packer installed, you can create a Packer template. In this repo we have several examples of Packer templates. You can use the `packer-for-image-generation` folder to create a custom image with Packer.

But first we need to create a new gallery for these packages. You can create this resources using the terrafom script in the `terraform` folder.

After that you need to create a service principal to use with Packer. You can create a service principal with the following command:

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac --name hcp-packer --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID
```

And create a variables.pkr.hcl file with the following content:

```hcl
variable "client_id" {
  type = string
  #   default = "${env("ARM_CLIENT_ID")}"
  default = "5cb59efc-01fa-4d67-8c4d-4a14111f163b"
}
variable "client_secret" {
  type = string
  #   default = "${env("ARM_CLIENT_SECRET")}"
  default = "IaP8Q~RrGH~~5AkDOhVIMnpsbii0a5stje-SNbxY"
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

variable "gallery_resource_group" {
  type    = string
  default = "packer-rg"
}

variable "gallery_name" {
  type    = string
  default = "packer_gallery"
}

```

You need at least these variables and for each Packer template you have to specify the name of the image and the versio:

```hcl
variable "image_name" {
  type    = string
  default = "jetbrains"
}

variable "image_version" {
  type    = string
  default = "1.0.0"
}
```

```bash
cd packer-for-image-generation
cd jetbrains
packer init .
packer build .
```

You can repeat this process for each Packer template you have.

### Create a Dev Center 🏢

Now that you have a virtual network and also a custom image let's create a Dev Center. This is the place where you will manage your projects. You have to give the Dev Center permissions to the gallery

```bash
source scripts/06-create-dev-center.sh
```


### Create a Project 📝

Projects in Dev Box should represent a team or a group of people that will use the same dev boxes. For example, you can create a project for your backend team, another for your frontend team, and so on.

```bash
source scripts/07-create-a-project.sh
```

### Create a network connections 📞

If you need to connect to a virtual network, you can create a network connection. A network connection is a connection between a dev box and a virtual network. You can create a network connection for each virtual network that you want to connect to a dev box. After you create a network connection, you have to attach it to a dev center.

```bash
source scripts/09-create-network-connections.sh
```

### Create a Dev Box Definition 📦

Dev Box definitions are created within a project and they carry information about the dev box and any requirements for using it to create VMs. This includes the image version, the size of the VM, and the network connections. It's a definition of a type of dev box.

We have a couple of options here: you can create a dev box definition with some of the images from the default gallery, and in this demo connected to a virtual network:

```bash
source scripts/08-create-dev-box-definition.sh
```

Or we can create dev box definitions for the images created with Packer:

```bash
source scripts/08.1-create-dev-box-definitions-for-packer-images.sh
```

### Create a dev box pool 🖥️

Now that you have a dev box definition, you can create a dev box pool in your project. A dev box pool is a set of dev boxes that are created from the same dev box definition. 

```bash
source scripts/10-create-dev-box-pool.sh
```

### Got to the developer portal and create a dev box 👩🏼‍💻

The URL for the developer portal is https://devportal.microsoft.com

### Check the usage

```bash
source scripts/11-check-usage.sh
```

### Clean up

Congratulations 🎉 You did it! Now you can delete all and go to sleep 🛌💤

```bash
source scripts/12-clean-up.sh
```

### Customizations

Comming soon 🚧!

#### Dev Box extension for VS Code

You can install the [Dev Box extension for VS Code](https://marketplace.visualstudio.com/items?itemName=DevCenter.ms-devbox) to manage your dev boxes directly from your IDE.

### Azure Deployments

An environment definition is composed of least two files:

- An Azure Resource Manager template (ARM template) in JSON file format. For example, azuredeploy.json.
- A configuration file that provides metadata about the template. This file should be named environment.yaml.

You can see some examples in the `catalog` folder.