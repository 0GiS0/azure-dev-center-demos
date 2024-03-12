project_name=${projects_names[1]}

DEV_BOX_POOL_WITH_VNET_INTEGRATIOn="pool_with_vnet"

echo -e "Creating a dev box pool with vnet integration for project $project_name"

time az devcenter admin pool create \
--name $DEV_BOX_POOL_WITH_VNET_INTEGRATIOn \
--project-name $project_name \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_FOR_VNET_INTEGRATION \
--local-administrator Enabled \
--virtual-network-type Unmanaged \
--network-connection-name "$VNET_NAME-attached-network" 