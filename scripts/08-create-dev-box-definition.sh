echo -e "Checking all galleries available for $DEV_CENTER_NAME"

az devcenter admin gallery list \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
-o table

echo -e "And also all the images"

az devcenter admin image list \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
-o table

IMAGE_REFERENCE_ID=$(az devcenter admin image show \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--gallery-name $GALLERY_NAME \
--name $IMAGE_DEF \
--query id -o tsv)

echo -e "You can get all skus to see how many CPU, memmory and XX you want"

az devcenter admin sku list -o table

time az devcenter admin devbox-definition create \
--name $DEV_BOX_DEFINITION_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--image-reference id=$IMAGE_REFERENCE_ID \
--os-storage-type $STORAGE_TYPE \
--sku name="$SKU_NAME"