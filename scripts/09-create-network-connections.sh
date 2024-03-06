echo -e "Create network connection"

NETWORK_CONNECTION_ID=$(az devcenter admin network-connection create \
--name "$VNET_NAME-connection" \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--domain-join-type "AzureAdJoin" \
--networking-resource-group-name $RESOURCE_GROUP-vnet \
--subnet-id $(az network vnet subnet show --name $SUBNET_NAME --vnet-name $VNET_NAME --resource-group $RESOURCE_GROUP --query id -o tsv) \
--query id -o tsv)

# az devcenter admin network-connection list --resource-group $RESOURCE_GROUP -o table

az devcenter admin attached-network create \
--name "$VNET_NAME-attached-network" \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--network-connection-id $NETWORK_CONNECTION_ID
