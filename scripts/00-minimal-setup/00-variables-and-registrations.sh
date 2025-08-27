#!/bin/bash

# Registrations for your subscription
az feature register --name VMHibernationPreview --namespace Microsoft.Compute
az provider register --namespace Microsoft.KeyVault --wait

# General variables
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
RESOURCE_GROUP="devbox-demos"
LOCATION="westeurope"

# Dev center variables
DEV_CENTER_NAME="heroes-devcenter"

# Virtual network variables
VNET_NAME="devbox-vnet"
SUBNET_NAME="devboxes-subnet"

# Key vault variables
KEY_VAULT_NAME="heroes-center-kv"
SECRET_NAME="gh-pat"

# Gallery image variables
# For Image Builder
IMAGE_BUILDER_GALLERY_NAME="image_builder_gallery"
VSCODE_IMAGE_DEFINITION="vscode_image_def"

# Image Builder variables
IMAGE_BUILDER_IDENTITY="image-builder-identity"
DEV_BOX_FOR_CUSTOM_IMAGE_WITH_IMAGE_BUILDER="vscode-definition-from-ib"
CUSTOM_IMAGE_DEV_BOX_POOL_NAME="the-avengers-pool"

# Custom image
VSCODE_IMAGE_NAME="vscode_image"
VSCODE_RUN_OUTPUT_NAME="vscodeWinImageRunOutput"
VSCODE_IMAGE_TEMPLATE="vscode_template"

# For Packer
PACKER_GALLERY_NAME="packer_gallery"
PACKER_GALLERY_RESOURCE_GROUP="packer-rg"

# Project
ENTRA_ID_GROUP_NAME="Devs"
group_names=("Devs")

# Size of the dev box
STORAGE_TYPE="ssd_256gb"
SKU_NAME="general_i_8c32gb256ssd_v2"

# Variables for the basic dev box
DEV_BOX_DEFINITION_FOR_BASIC_DEMO="visualstudio2022"
DEV_BOX_POOL_NAME_FOR_BASIC_DEVBOX="justice-league-pool"
IMAGE_NAME_FROM_THE_DEFAULT_GALLERY="microsoftvisualstudio_windowsplustools_base-win11-gen2"

# Dev box customizations
TASK_CATALOG_NAME="tasks-catalog"
PROJECT_TASK_CATALOG_NAME="team-customization-files"

# Azure Deployment Environments
CATALOG_NAME="infra-catalog"
PROJECT_FOR_ENVIRONMENTS="tour-of-heroes-environments"
DEV_ENVIRONMENT_TYPE="dev"

gum style --foreground 212 --bold "✨ Variables set ✨"

# name of the images
image_names=("jetbrains")

projects_names=("marvel-project" "dc-project" "dark-horse-project")

# If you want to replace some of these values, you can create a .env file with the values you want to replace
# Check if .env file exists
if [ ! -f .env ]; then
    gum style --foreground 196 --bold "❌ .env file does not exist 😢"
    exit 1
fi

set -o allexport
source .env
set +o allexport

# Add a summary of the variables
gum style --foreground 51 --bold "🔎 Summary of variables used:"

# General variables
gum style --foreground 45 --bold "🌐 General Configuration:"
(
   echo "Variable,Value" 
   echo "SUBSCRIPTION_ID,$SUBSCRIPTION_ID" 
   echo "RESOURCE_GROUP,$RESOURCE_GROUP" 
   echo "LOCATION,$LOCATION" 
   echo "DEV_CENTER_NAME,$DEV_CENTER_NAME"
) | gum table --print

# Network variables
gum style --foreground 45 --bold "🛜 Network Configuration:"
(
  echo "Variable,Value"
  echo "VNET_NAME,$VNET_NAME"
  echo "SUBNET_NAME,$SUBNET_NAME"
) | gum table --print

# Security variables
gum style --foreground 45 --bold "🔒 Security Configuration:"
(
  echo "Variable,Value"
  echo "KEY_VAULT_NAME,$KEY_VAULT_NAME"
  echo "SECRET_NAME,$SECRET_NAME"
) | gum table --print

# Image Builder variables
gum style --foreground 45 --bold "🖼️ Image Builder Configuration:"
(
  echo "Variable,Value"
  echo "IMAGE_BUILDER_GALLERY_NAME,$IMAGE_BUILDER_GALLERY_NAME"
  echo "VSCODE_IMAGE_DEFINITION,$VSCODE_IMAGE_DEFINITION"
  echo "IMAGE_BUILDER_IDENTITY,$IMAGE_BUILDER_IDENTITY"
  echo "CUSTOM_IMAGE_DEV_BOX_POOL_NAME,$CUSTOM_IMAGE_DEV_BOX_POOL_NAME"
  echo "VSCODE_IMAGE_NAME,$VSCODE_IMAGE_NAME"
  echo "VSCODE_RUN_OUTPUT_NAME,$VSCODE_RUN_OUTPUT_NAME"
  echo "VSCODE_IMAGE_TEMPLATE,$VSCODE_IMAGE_TEMPLATE"
) | gum table --print

# Packer variables
gum style --foreground 45 --bold "📦 Packer Configuration:"
(
  echo "Variable,Value"
  echo "PACKER_GALLERY_NAME,$PACKER_GALLERY_NAME"
  echo "PACKER_GALLERY_RESOURCE_GROUP,$PACKER_GALLERY_RESOURCE_GROUP"
) | gum table --print

# Dev Box variables
gum style --foreground 45 --bold "💻 Dev Box Configuration:"
(
  echo "Variable,Value"
  echo "ENTRA_ID_GROUP_NAME,$ENTRA_ID_GROUP_NAME"
  echo "STORAGE_TYPE,$STORAGE_TYPE"
  echo "SKU_NAME,$SKU_NAME"
  echo "DEV_BOX_DEFINITION_FOR_BASIC_DEMO,$DEV_BOX_DEFINITION_FOR_BASIC_DEMO"
  echo "DEV_BOX_POOL_NAME_FOR_BASIC_DEVBOX,$DEV_BOX_POOL_NAME_FOR_BASIC_DEVBOX"
  echo "IMAGE_NAME_FROM_THE_DEFAULT_GALLERY,$IMAGE_NAME_FROM_THE_DEFAULT_GALLERY"
) | gum table --print

# Dev Box customizations
gum style --foreground 45 --bold "🛠️ Dev Box Customization Configuration:"
(
  echo "Variable,Value"
  echo "TASK_CATALOG_NAME,$TASK_CATALOG_NAME"
  echo "PROJECT_TASK_CATALOG_NAME,$PROJECT_TASK_CATALOG_NAME"

) | gum table --print

# Environment variables
gum style --foreground 45 --bold "🌍 Environment Configuration:"
(
  echo "Variable,Value"
  echo "CATALOG_NAME,$CATALOG_NAME"
  echo "PROJECT_FOR_ENVIRONMENTS,$PROJECT_FOR_ENVIRONMENTS"
  echo "DEV_ENVIRONMENT_TYPE,$DEV_ENVIRONMENT_TYPE"
) | gum table --print

# Arrays summary
gum style --foreground 36 --bold "📦 Projects: ${projects_names[*]}"
gum style --foreground 36 --bold "🖼️ Images: ${image_names[*]}"
gum style --foreground 36 --bold "👥 Groups: ${group_names[*]}"
