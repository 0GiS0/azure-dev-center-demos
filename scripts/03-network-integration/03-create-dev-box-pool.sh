project_name=${projects_names[0]}

DEV_BOX_POOL_WITH_VNET_INTEGRATIOn="pool-with-vnet-connection"

echo -e "Creating a dev box pool with vnet integration for project $project_name"

time az devcenter admin pool create \
--name $DEV_BOX_POOL_WITH_VNET_INTEGRATIOn \
--project-name $project_name \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_FOR_BASIC_DEMO \
--local-administrator Enabled \
--virtual-network-type Unmanaged \
--network-connection-name "$VNET_NAME-attached-network" 