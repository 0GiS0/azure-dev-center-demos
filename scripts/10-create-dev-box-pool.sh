echo -e "Create Dev Box pool $DEV_BOX_POOL_NAME"

time az devcenter admin pool create \
--name "${DEV_BOX_POOL_NAME}_with_vnet" \
--project-name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_NAME \
--local-administrator Enabled \
--virtual-network-type Unmanaged \
--network-connection-name "$VNET_NAME-attached-network" 