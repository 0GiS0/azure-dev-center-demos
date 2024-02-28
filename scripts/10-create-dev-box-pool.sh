echo -e "Create Dev Box pool $DEV_BOX_POOL_NAME"

az devcenter admin pool create \
--name $DEV_BOX_POOL_NAME \
--project-name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_NAME \
--local-administrator Enabled \
--virtual-network-type Managed \
--managed-virtual-network-regions $LOCATION