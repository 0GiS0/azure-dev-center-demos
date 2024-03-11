echo -e "Creating resource group $RESOURCE_GROUP in $LOCATION"

az group create \
--name $RESOURCE_GROUP \
--location $LOCATION