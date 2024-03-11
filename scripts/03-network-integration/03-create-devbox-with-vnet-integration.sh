IMAGE_REFERENCE_ID=$(az devcenter admin image show \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--gallery-name Default \
--name  "microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365" \
--query id -o tsv)

echo -e "You can get all skus to see how many CPU, memmory and XX you want"

az devcenter admin sku list -o table

time az devcenter admin devbox-definition create \
--name $DEV_BOX_DEFINITION_NAME_FOR_A_DEFAULT_IMAGE \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--image-reference id=$IMAGE_REFERENCE_ID \
--os-storage-type $STORAGE_TYPE \
--sku name="$SKU_NAME"