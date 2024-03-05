DEV_BOX_POOL_NAME_WITH_PACKER_IMAGE="dev-box-pool-with-packer-image"

echo -e "Create Dev Box pool $DEV_BOX_POOL_NAME"

az devcenter admin pool create \
--name $DEV_BOX_POOL_NAME_WITH_PACKER_IMAGE \
--project-name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_NAME_FOR_PACKER_IMAGES \
--local-administrator Enabled \
--virtual-network-type Managed \
--managed-virtual-network-regions $LOCATION \


az devcenter admin pool delete \
--name $DEV_BOX_POOL_NAME_WITH_PACKER_IMAGE \
--project-name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP

