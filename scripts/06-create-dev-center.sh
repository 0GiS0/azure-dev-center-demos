
echo -e "Creating Dev Center $DEV_CENTER_NAME"

DEV_CENTER_ID=$(az devcenter admin devcenter create \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--identity-type "SystemAssigned" \
--query id -o tsv)

DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

echo "Let's assign the Contributor role to the Dev Center for the gallery"

az role assignment create \
--role "Contributor" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope $(az sig show --gallery-name $GALLERY_NAME \
--resource-group $RESOURCE_GROUP --query id -o tsv)

echo "Then you can associate the gallery with the Dev Center"

az devcenter admin gallery create \
--name $GALLERY_NAME \
--gallery-resource-id $(az sig show --gallery-name $GALLERY_NAME --resource-group $RESOURCE_GROUP --query id -o tsv) \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP
