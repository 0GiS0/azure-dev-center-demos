### Install Azure DevBox extension 🧩

```bash
az extension add --name devcenter
```

### Set variables

To make it easier to follow the tutorial, let's set some variables.

```bash
source scripts/00-variables-and-registrations.sh
```


### Create a Resource Group 📦 and virtual network 🕸️

As every Azure resource, the first thing you need to do is to create a resource group.
Also, in a enterprise environment, you will probably want to create a virtual network to connect your dev boxes to your corporate network.

```bash
source scripts/01-create-rg-and-vnet.sh
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

### Create image template with Packerr 

The first thing you need to do is to install Packer. You can download it from the Packer website. Once you have Packer installed, you can create a Packer template. A Packer template is a JSON file that configures the various components of Packer in order to create a machine image. 

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac --name hcp-packer --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID
```

Create a variables.pkr.hcl file with the following content:

```hcl
variable "subscription_id" {
  type    = string
  default = "your-subscription-id"
}

variable "client_id" {
  type    = string
  default = "your-client-id"
}

variable "client_secret" {
  type    = string
  default =
}

variable "tenant_id" {
  type    = string
  default = "your-tenant-id"
}

variable "resource_group_name" {
  type    = string
  default = "your-resource-group-name"
}

variable "location" {
  type    = string
  default = "your-location"
}
```

Now you can execute packer to create the image:

```bash
az group create --name hcp-packer-demos --location westeurope
```

```bash
cd packer-for-image-generation
packer init .
packer build .
```

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

### Create a Dev Box Definition 📦

```bash
source scripts/08-create-dev-box-definition.sh
```

### Create a network connections 📞

```bash
source scripts/09-create-network-connections.sh
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