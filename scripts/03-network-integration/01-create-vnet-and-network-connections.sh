echo -e "Creating virtual network $VNET_NAME with subnet $SUBNET_NAME"

az network vnet create \
--name $VNET_NAME \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--address-prefixes 192.168.0.0/16 \
--subnet-name $SUBNET_NAME \
--subnet-prefix 192.168.1.0/24

echo -e "Create network connection"

NETWORK_CONNECTION_ID=$(az devcenter admin network-connection create \
--name "$VNET_NAME-connection" \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--domain-join-type "AzureAdJoin" \
--networking-resource-group-name $RESOURCE_GROUP-vnet \
--subnet-id $(az network vnet subnet show --name $SUBNET_NAME --vnet-name $VNET_NAME --resource-group $RESOURCE_GROUP --query id -o tsv) \
--query id -o tsv)

az devcenter admin network-connection list --resource-group $RESOURCE_GROUP -o table

az devcenter admin attached-network create \
--name "$VNET_NAME-attached-network" \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--network-connection-id $NETWORK_CONNECTION_ID
