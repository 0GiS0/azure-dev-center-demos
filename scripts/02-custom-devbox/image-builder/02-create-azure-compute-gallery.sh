echo -e "Creating Azure Compute Gallery $GALLERY_NAME in $LOCATION"

az sig create \
--resource-group $RESOURCE_GROUP \
--gallery-name $GALLERY_NAME \
--location $LOCATION

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