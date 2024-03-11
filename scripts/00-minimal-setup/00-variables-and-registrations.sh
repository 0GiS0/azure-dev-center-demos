#!/bin/bash

#Check if .env file exists
if [ ! -f .env ]; then
    echo -e "File .env does not exist"
    exit 1
fi

set -o allexport
source .env
set +o allexport



# General variables
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
RESOURCE_GROUP="DevBoxDemos"
LOCATION="westeurope"

# Virtual network variables
VNET_NAME="devbox-vnet"
SUBNET_NAME="devboxes-subnet"

# Key vault variables
KEY_VAULT_NAME="madriddevcenterkv"
SECRET_NAME="gh-pat"

# Gallery image variables
# For Image Builder
GALLERY_NAME="devbox_gallery"
# For Packer
PACKER_GALLERY_NAME="packer_gallery"
PACKER_GALLERY_RESOURCE_GROUP="packer-rg"

# Custom images variables
# IMAGE_DEF="vscodeImage"
VSCODE_IMAGE_DEFINITION="vscodeImage"

# Image Builder variables
IMAGE_BUILDER_IDENTITY="image-builder-identity"

# Custom image
VSCODE_IMAGE_NAME="vscodeWinImage"
VSCODE_RUN_OUTPUT_NAME="vscodeWinImageRunOutput"
VSCODE_IMAGE_TEMPLATE="vscodeTemplate"

# Dev center variables
DEV_CENTER_NAME=madrid-dev-center

# Project
# USER_EMAIL="gis@MngEnvMCAP434473.onmicrosoft.com"
ENTRA_ID_GROUP_NAME="Devs"

# Dev Box Definition variables
SKU_NAME="general_i_8c32gb256ssd_v2"
# DEV_BOX_DEFINITION_NAME="vscode-box"
DEV_BOX_DEFINITION_NAME_FOR_A_DEFAULT_IMAGE="win11_en_os_optimized"
STORAGE_TYPE="ssd_256gb"

# Dev Box Pool
DEV_BOX_POOL_NAME="backend-team-pool"

# Azure Deployment Environments
CATALOG_NAME="my-catalog"
PROJECT_FOR_ENVIRONMENTS="tour-of-heroes-environments"
DEV_ENVIRONMENT_TYPE="dev"

echo -e "Variables set"

# Registrations for your suscription

az feature register --name VMHibernationPreview --namespace Microsoft.Compute