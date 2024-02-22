## Install Azure DevBox extension

```bash
az extension add --name devcenter
```

### Create a Resource Group 📦

As every Azure resource, the first thing you need to do is to create a resource group.

```bash
RESOURCE_GROUP="DevBoxDemos"
LOCATION="westeurope"

az group create --name $RESOURCE_GROUP --location $LOCATION
```

### Create a Dev Center 🏢

The first thing you need to do is to create a Dev Center. This is the place where you will manage your projects.

```bash
DEV_CENTER_NAME=returngis-dev-center

DEV_CENTER_ID=$(az devcenter admin devcenter create \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query id -o tsv)
```

### Create a Project 📝

```bash
DEV_CENTER_PROJECT="my-project"

az devcenter admin project create \
--name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP \
--dev-center-id $DEV_CENTER_ID \
--max-dev-boxes-per-user 2
```

### Create a Dev Box Definition 📦

#### Get image reference id

```bash
az devcenter admin image list \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
-o table
```

For this example, we'll use Visual Studio 2022 Enterprise on Windows 11 Enterprise + Microsoft 365 Apps 23H2

```bash
IMAGE_NAME="microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

IMAGE_REFERENCE_ID=$(az devcenter admin image show \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--gallery-name "Default" \
--name $IMAGE_NAME \
--query id -o tsv)
```

As you can see I use the `--gallery-name "Default"` parameter. This is because the image is in the default gallery. If you want to use a custom gallery, you need to specify the gallery name.

You can check all the available galleries with the following command:

```bash
az devcenter admin gallery list \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
-o table
```

#### How to get the available SKUs

```bash
az devcenter admin sku list -o table

SKU_NAME="general_i_8c32gb256ssd_v2"
```



And now, we can create the Dev Box Definition

```bash
DEV_BOX_DEFINITION_NAME="vs2022-box"

az devcenter admin devbox-definition create \
--name $DEV_BOX_DEFINITION_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--image-reference id=$IMAGE_REFERENCE_ID \
--os-storage-type "ssd_256gb" \
--sku name="$SKU_NAME" \
--hibernate-support Enabled
```

<!-- #### Create a network connection

##### Create a virtual network -->

#### Create a dev box pool

Now that you have a dev box definition, you can create a dev box pool in your project. A dev box pool is a set of dev boxes that are created from the same dev box definition. 

```bash
DEV_BOX_POOL_NAME="backend-team-pool"

az devcenter admin pool create \
--name $DEV_BOX_POOL_NAME \
--project-name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_NAME \
--local-administrator Disabled \
--virtual-network-type Managed \
--managed-virtual-network-regions "westeurope"
```

##### Provide access to a dev project

##### Assign DevCenter Dev Box User role to a user

```bash
USER_EMAIL="<YOUR_USER_FOR_DEMOS>"

az role assignment create \
--role "DevCenter Dev Box User" \
--assignee $USER_EMAIL \
--scope $(az devcenter admin project show --name $DEV_CENTER_PROJECT --resource-group $RESOURCE_GROUP --query id -o tsv)
```

#### Got to the developer portal and create a dev box

The URL for the developer portal is https://devportal.microsoft.com

You should see something like this:

<img src="images/Dev Box portal.png" />

And once you launch the dev box you can configure `In Session Settings`:

<img src="images/In Session Settings.png" />

### Check the usage

```bash
az devcenter admin usage list -l $LOCATION \
--query "[].{name:name.value, currentValue:currentValue}" \
-o table
```

You'll get something like this:

```bash
Name                CurrentValue
------------------  --------------
devBoxDefinitions   2
devCenters          2
general_i_v2        8
networkConnections  0
general_a_v1        0
general_a_v2        0
pools               0
projects            0
```