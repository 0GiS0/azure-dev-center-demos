echo -e "Creating Azure Compute Gallery $GALLERY_NAME in $LOCATION"

az sig create \
--resource-group $RESOURCE_GROUP \
--gallery-name $GALLERY_NAME \
--location $LOCATION