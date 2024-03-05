VSCODE_PACKER_IMAGE_DEFINITION="VSCodeWithPacker"

PACKER_IMAGE_REFERENCE_ID=$(az devcenter admin image show \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--gallery-name $PACKER_GALLERY_NAME \
--name $VSCODE_PACKER_IMAGE_DEFINITION \
--query id -o tsv)

DEV_BOX_DEFINITION_NAME_FOR_PACKER_IMAGES="devbox-definition-for-packer-images"

time az devcenter admin devbox-definition create \
--name $DEV_BOX_DEFINITION_NAME_FOR_PACKER_IMAGES \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--image-reference id=$PACKER_IMAGE_REFERENCE_ID \
--os-storage-type $STORAGE_TYPE \
--sku name="$SKU_NAME"

time az devcenter admin devbox-definition delete \
--name $DEV_BOX_DEFINITION_NAME_FOR_PACKER_IMAGES \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP
