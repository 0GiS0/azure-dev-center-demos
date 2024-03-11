

time az devcenter admin pool create \
--name "${DEV_BOX_POOL_NAME}_with_vnet" \
--project-name $project_name \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_NAME_FOR_A_DEFAULT_IMAGE \
--local-administrator Enabled \
--virtual-network-type Unmanaged \
--network-connection-name "$VNET_NAME-attached-network" 