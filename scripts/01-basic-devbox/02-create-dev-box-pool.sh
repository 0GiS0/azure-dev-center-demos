project_name=${projects_names[0]}

gum style --foreground 212 "🏗️ Creating Dev Box pool $DEV_BOX_POOL_NAME_FOR_BASIC_DEVBOX in project $project_name"

time az devcenter admin pool create \
--name "${DEV_BOX_POOL_NAME_FOR_BASIC_DEVBOX}" \
--project-name $project_name \
--resource-group $RESOURCE_GROUP \
--devbox-definition-name $DEV_BOX_DEFINITION_FOR_BASIC_DEMO \
--local-administrator Enabled \
--virtual-network-type Managed \
--managed-virtual-network-regions $LOCATION
