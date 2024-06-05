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
source scripts/00-minimal-setup/00-variables-and-registrations.sh
```

<details>
<summary>
<h4>Minimal setup: resource group 📦, Dev Center 🏢 and projects 👷🏼‍♀️👷🏻‍♂️</h4>
</summary>

##### Create a resource Group 📦 

As every Azure resource, the first thing you need to do is to create a resource group.
Also, in a enterprise environment, you will probably want to create a virtual network to connect your dev boxes to your corporate network.

```bash
source scripts/00-minimal-setup/01-create-rg.sh
```

##### Create a Dev Center 🏢

Now that you have a virtual network and also a custom image let's create a Dev Center. This is the place where you will manage your projects. You have to give the Dev Center permissions to the gallery

```bash
source scripts/00-minimal-setup/02-create-dev-center.sh
```

##### Create some projects 👷🏼‍♀️👷🏻‍♂️

Projects in Dev Box should represent a team or a group of people that will use the same dev boxes. For example, you can create a project for your backend team, another for your frontend team, and so on.

```bash
source scripts/00-minimal-setup/03-create-projects.sh
```

</details>

<details>
<summary><h4>Basic setup: Create a Dev Box with a image from the Azure Marketplace</h4></summary>

### Create a Dev Box Definition 📦

Dev Box definitions are created within a project and they carry information about the dev box and any requirements for using it to create VMs. This includes the image version, the size of the VM, and the virtual network to connect to.

```bash
source scripts/01-basic-devbox/01-create-dev-box-definition.sh
```

### Create a Dev Box Pool 

A dev box pool is a collection of dev boxes that are created from the same dev box definition. You can create a dev box pool for each team or group of people that will use the same dev boxes.

```bash
source scripts/01-basic-devbox/02-create-dev-box-pool.sh
```

### Access to the Developer Portal

Congrats 🎉, you have created a dev box pool. Now you can access the Developer Portal and create a new dev box.

The URL for the developer portal is https://devportal.microsoft.com

You can access with any user in the Devs group 👩🏼‍💻👨🏻‍💻

</details>

<details>
<summary><h4>Create a custom image</h4></summary>

We have two options to create a custom image: using Azure Image Builder or using Packer.

### Using Azure Image Builder

Azure Image Builder is a service that allows you to create custom images in Azure. You can use it to create a custom image from a managed image, a shared image gallery image, or a generalized VM. You can also use it to create a custom image from a Packer template.

### Create a Gallery 🖼

The first thing we need is a gallery. 

```bash
source scripts/02-custom-devbox/image-builder/01-create-azure-compute-gallery.sh
```

### Create the image definition ✏

Image definitions are created within a gallery and they carry information about the image and any requirements for using it to create VMs. This includes whether the image is Windows or Linux, release notes, and minimum and maximum memory requirements. It's a definition of a type of image.

```bash
source scripts/02-custom-devbox/image-builder/02-create-image-definition.sh
```

### Create image version 🏞️

An image version is what you use to create a VM when using a gallery. You can have multiple versions of an image as needed for your environment. Like a managed image, when you use an image version to create a VM, the image version is used to create new disks for the VM. Image versions can be used multiple times.

In order to create your custom image you can use Azure Image Builder and for that you need a identity. This identity needs some permissions but there is no built-in role. So let's create a custom role for the image builder too.

```bash
source scripts/02-custom-devbox/image-builder/03-create-azure-image-builder-identity-and-role.sh
```

Lastly you need to define the ingredients for your new image: what is the image base, if some customization is needed and how much time it has the builder to build it.

We are going to use this template: `custom-images/win11-with-vscode.json` which install Visual Studio Code in a Windows 11.

```bash
source scripts/02-custom-devbox/image-builder/04-create-an-image-template.sh
```

And now just wait... a little bit ⌚

Congrats 🎉, you have created a custom image. Now you can use it to create a new dev box.

```bash
source scripts/02-custom-devbox/image-builder/05-create-dev-box-definition.sh
```

After that you can create a dev box pool 

```bash
source scripts/02-custom-devbox/image-builder/06-create-dev-box-pool.sh
```

and access the Developer Portal to create a new dev box. 

Developer Portal URL: https://devportal.microsoft.com

You should see a Windows 11 with VS Code installed.

### Create image template with Packer

The other option to create a custom image is to use Packer. Packer is a tool for creating identical machine images for multiple platforms from a single source configuration. 

The first thing you need to do is to [install Packer](https://developer.hashicorp.com/packer/install?product_intent=packer). Once you have Packer installed, you can create a Packer template. In this repo we have several examples of Packer templates. You can use the `packer-for-image-generation` folder to create a custom image with Packer.

But first we need to create a new gallery for these packages. In order to execute packer you need a service principal:

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac --name hcp-packer --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID
```

>IMPORTANT: Please replace the `variables.pkr.hcl` file with your own values.

With that in place, you can create this resources using the terrafom script in the `terraform` folder.

```bash
source scripts/02-custom-devbox/packer/01-create-resources-using-tf.sh
```

Once you have the custom images created, you need to attach the gallery to the Dev Center:

```bash
source scripts/02-custom-devbox/packer/02-assign-packer-gallery.sh
```

Create the Dev Box definitions:

```bash
source scripts/02-custom-devbox/packer/03-create-dev-box-definitions-for-packer-images.sh
```

And create the Dev Box Pools:

```bash
source scripts/02-custom-devbox/packer/04-create-dev-box-pool-with-packer-images.sh
```

Check the portal and create a new dev box with the new images.

https://devportal.microsoft.com

</details>

<details>
<summary><h4>Configuration-as-code customization (preview)</h4></summary>

You can use configuration-as-code to customize the dev box. Configuration-as-code allows you to define the configuration of a dev box in a YAML file. You can use configuration-as-code to customize the dev box by installing software, configuring settings, and running scripts.

But first platform admin teams must choose which tasks are available to their developers by defining a Catalog of tasks. A Catalog is a collection of tasks that developers can use to customize their dev boxes. Each task in the catalog is a YAML file that defines a task that can be run on a dev box plus a script that is executed when the task is run.

For this environment we are going to allow the tasks in the `allowed-tasks` folder. So we need to attach this folder to the Dev Center.

```bash
source scripts/02-custom-devbox/customizations/00-attach-catalog-with-allowed-tasks.sh
```

So now you can create a new dev box with some customizations. Just go to the Developer Portal and upload the `devbox-customizations/workload.yaml` file.
After creation you should see all this installed:

- Visual Studio Code

</details>

<details>
<summary><h4>Integrate Dev Box with a virtual network</h4></summary

### Create a network connections 📞

If you need to connect to a virtual network, you can create a network connection. A network connection is a connection between a dev box and a virtual network. You can create a network connection for each virtual network that you want to connect to a dev box. After you create a network connection, you have to attach it to a dev center.

```bash
source scripts/03-network-integration/01-create-vnet-and-network-connections.sh
```

##### Create a SQL Server virtual machine  in the vnet

```bash
source scripts/03-network-integration/02-create-vm-with-sql-server-in-that-vnet.sh
```

##### Create a devbox definition with an image with Azure Data Studio in order to connect to the SQL Server

```bash
source scripts/03-network-integration/03-create-devbox-with-vnet-integration.sh
```

##### Create a dev box pool 🖥️

Now that you have a dev box definition, you can create a dev box pool in your project. A dev box pool is a set of dev boxes that are created from the same dev box definition.

```bash
source scripts/03-network-integration/04-create-dev-box-pool.sh
```

### Got to the developer portal and create a dev box 👩🏼‍💻

The URL for the developer portal is https://devportal.microsoft.com

</details>

<details>
<summary><h4>Azure Deployment Environments</h4></summary

### Azure Deployments

An environment definition is composed of least two files:

- An Azure Resource Manager template (ARM template) in JSON file format. For example, azuredeploy.json.
- A configuration file that provides metadata about the template. This file should be named environment.yaml.

You can see some examples in the `catalog` folder.

```bash
source scripts/04-environments/01-create-a-catalog.sh
```

### How to define environments

You can use BICEP and then convert it to ARM template.

```bash
az bicep build --file {bicep_file} --outfile {out_file}
```

for example:

```bash
az bicep build --file catalog/ARMTemplates/tour-of-heroes-environment/main.bicep --outfile catalog/ARMTemplates/tour-of-heroes-environment/azuredeploy.json
```

Or, in private preview, you can use Terraform.

Schedule an environment for deletion as a project admin: https://learn.microsoft.com/en-us/azure/deployment-environments/how-to-schedule-environment-deletion#schedule-an-environment-for-deletion-as-a-project-admin


</details>

<details>
<summary><h4>Check the usage</h4>

```bash
source scripts/11-check-usage.sh
```
</details>


### Clean up

Congratulations 🎉 You did it! Now you can delete all and go to sleep 🛌💤

Please keep in mind that before you delete the resources, you need to delete the environments created by the users.

```bash
source scripts/clean-up.sh
```
