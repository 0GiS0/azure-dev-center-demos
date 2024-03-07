echo -e "Creating resource group $RESOURCE_GROUP in $LOCATION"

az group create \
--name $RESOURCE_GROUP \
--location $LOCATION

echo -e "Creating virtual network $VNET_NAME with subnet $SUBNET_NAME"

az network vnet create \
--name $VNET_NAME \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--address-prefixes 192.168.0.0/16 \
--subnet-name $SUBNET_NAME \
--subnet-prefix 192.168.1.0/24