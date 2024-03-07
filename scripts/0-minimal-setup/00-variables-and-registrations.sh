#!/bin/bash

# General variables
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
RESOURCE_GROUP="DevBoxDemos"
LOCATION="westeurope"

# Virtual network variables
VNET_NAME="devbox-vnet"
SUBNET_NAME="devboxes-subnet"

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
DEV_CENTER_PROJECT="tour-of-heroes-project"
USER_EMAIL="gis@MngEnvMCAP434473.onmicrosoft.com"

# Dev Box Definition variables
SKU_NAME="general_i_8c32gb256ssd_v2"
# DEV_BOX_DEFINITION_NAME="vscode-box"
DEV_BOX_DEFINITION_NAME_FOR_A_DEFAULT_IMAGE="win11_en_os_optimized"
STORAGE_TYPE="ssd_256gb"

# Dev Box Pool
DEV_BOX_POOL_NAME="backend-team-pool"

echo -e "Variables set"

# Registrations for your suscription

az feature register --name VMHibernationPreview --namespace Microsoft.Compute