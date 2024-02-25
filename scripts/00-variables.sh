# General variables
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
RESOURCE_GROUP="DevBoxDemos"
LOCATION="westeurope"

# Virtual network variables
VNET_NAME="devbox-vnet"
SUBNET_NAME="devboxes-subnet"

# Gallery image variables
GALLERY_NAME="returngis_gallery"

# Custom images variables
IMAGE_DEF="vscodeImageDef"

# Image Builder variables
IMAGE_BUILDER_IDENTITY="imagebuilderidentity"

# Custom image
IMAGE_NAME="vscodeWinImage"
RUN_OUTPUT_NAME="vscodeWinImageRunOutput"
IMAGE_TEMPLATE="vscodeWinTemplate"

# Dev center variables
DEV_CENTER_NAME=madrid-dev-center

# Project
DEV_CENTER_PROJECT="tour-of-heroes-project"
USER_EMAIL="gis@MngEnvMCAP434473.onmicrosoft.com"


# Dev Box Definition variables
SKU_NAME="general_i_8c32gb256ssd_v2"
DEV_BOX_DEFINITION_NAME="vscode-box"
STORAGE_TYPE="ssd_256gb"

# Dev Box Pool
DEV_BOX_POOL_NAME="backend-team-pool"


echo -e "Variables set"