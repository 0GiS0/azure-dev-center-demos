# Get the first value of the array projects_names
project_name=${projects_names[1]}

echo -e "Project name: $project_name"

echo -e "Create Dev Box pool $DEV_BOX_POOL_NAME"

# time az devcenter admin pool create \
# --name "${DEV_BOX_POOL_NAME}_with_vnet" \
# --project-name $project_name \
# --resource-group $RESOURCE_GROUP \
# --devbox-definition-name $DEV_BOX_DEFINITION_NAME_FOR_A_DEFAULT_IMAGE \
# --local-administrator Enabled \
# --virtual-network-type Unmanaged \
# --network-connection-name "$VNET_NAME-attached-network" 

time az devcenter admin pool create \
--name "${DEV_BOX_POOL_NAME}" \
--project-name $project_name \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_NAME_FOR_A_DEFAULT_IMAGE \
--local-administrator Enabled \
--virtual-network-type Managed \
--managed-virtual-network-regions $LOCATION
