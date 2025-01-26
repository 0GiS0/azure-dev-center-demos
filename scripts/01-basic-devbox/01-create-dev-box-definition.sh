IMAGE_REFERENCE_ID=$(az devcenter admin image show \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--gallery-name Default \
--name "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2" \
--query id -o tsv)


time az devcenter admin devbox-definition create \
--name $DEV_BOX_DEFINITION_FOR_BASIC_DEMO \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--image-reference id=$IMAGE_REFERENCE_ID \
--os-storage-type $STORAGE_TYPE \
--sku name="$SKU_NAME" \
--hibernate-support Enabled