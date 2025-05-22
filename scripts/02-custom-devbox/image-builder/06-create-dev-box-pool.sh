project_name=${projects_names[0]}

echo -e "Create a dev box pool for project name: $project_name"

time az devcenter admin pool create \
--name "${CUSTOM_IMAGE_DEV_BOX_POOL_NAME}" \
--project-name $project_name \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_FOR_CUSTOM_IMAGE_WITH_IMAGE_BUILDER \
--local-administrator Enabled \
--virtual-network-type Managed \
--managed-virtual-network-regions $LOCATION \
--stop-on-disconnect status="Enabled" grace-period-minutes="60"
