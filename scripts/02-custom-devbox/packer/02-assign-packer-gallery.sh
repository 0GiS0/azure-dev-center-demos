DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

echo "Let's assign the Contributor role to the Dev Center for the gallery"

az role assignment create \
--role "Contributor" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope $(az sig show --gallery-name $PACKER_GALLERY_NAME \
--resource-group $PACKER_GALLERY_RESOURCE_GROUP --query id -o tsv)

echo "Then you can associate the gallery with the Dev Center"

az devcenter admin gallery create \
--name $PACKER_GALLERY_NAME \
--gallery-resource-id $(az sig show --gallery-name $PACKER_GALLERY_NAME --resource-group $PACKER_GALLERY_RESOURCE_GROUP --query id -o tsv) \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP