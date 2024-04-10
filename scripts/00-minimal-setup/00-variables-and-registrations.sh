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

# Dev center variables
DEV_CENTER_NAME=madrid-dev-center

# Virtual network variables
VNET_NAME="devbox-vnet"
SUBNET_NAME="devboxes-subnet"

# Key vault variables
# KEY_VAULT_NAME="devcenterkv${RANDOM}"
KEY_VAULT_NAME="devcenterkv10013"
SECRET_NAME="gh-pat"

# Gallery image variables
# For Image Builder
IMAGE_BUILDER_GALLERY_NAME="image_builder_gallery"
VSCODE_IMAGE_DEFINITION="vscodeImage"

# Image Builder variables
IMAGE_BUILDER_IDENTITY="image-builder-identity"
DEV_BOX_FOR_CUSTOM_IMAGE_WITH_IMAGE_BUILDER="devbox-for-custom-image-with-image-builder"
CUSTOM_IMAGE_DEV_BOX_POOL_NAME="custom-image-dev-box-pool"

# Custom image
VSCODE_IMAGE_NAME="vscodeWinImage"
VSCODE_RUN_OUTPUT_NAME="vscodeWinImageRunOutput"
VSCODE_IMAGE_TEMPLATE="vscodeTemplate"

# For Packer
PACKER_GALLERY_NAME="packer_gallery"
PACKER_GALLERY_RESOURCE_GROUP="packer-rg"

# Project
ENTRA_ID_GROUP_NAME="Devs"

# Size of the dev box
STORAGE_TYPE="ssd_256gb"
SKU_NAME="general_i_8c32gb256ssd_v2"

# Variables for the basic dev box
DEV_BOX_DEFINITION_FOR_BASIC_DEMO="vsbox"
DEV_BOX_POOL_NAME_FOR_BASIC_DEVBOX="default-gallery-pool"
IMAGE_NAME_FROM_THE_DEFAULT_GALLERY="microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

# Dev box customizations
TASK_CATALOG_NAME="tasks-catalog"

# Azure Deployment Environments
CATALOG_NAME="infra-catalog"
PROJECT_FOR_ENVIRONMENTS="tour-of-heroes-environments"
DEV_ENVIRONMENT_TYPE="dev"

echo -e "Variables set"

# Registrations for your suscription

az feature register --name VMHibernationPreview --namespace Microsoft.Compute

# name of the images
image_names=("vscode_with_extensions" "eclipse" "jetbrains" "secure_vscode" "docker")

projects_names=("tour-of-heroes-dotnet" "tour-of-heroes-java" "tour-of-heroes-python" "tour-of-heroes-containers" "tour-of-heroes-python")
