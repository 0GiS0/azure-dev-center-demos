echo -e "Creating Dev Center $DEV_CENTER_NAME"

DEV_CENTER_ID=$(az devcenter admin devcenter create \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--identity-type "SystemAssigned" \
--install-azure-monitor-agent-enable-status Enabled \
--project-catalog-item-sync-enable-status Enabled \
--query id -o tsv)

DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)