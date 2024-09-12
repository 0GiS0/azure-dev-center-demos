echo "Starting time: $(date)"

for image_name in "${image_names[@]}"
do
    echo "Creating dev box definition for $image_name"

    PACKER_IMAGE_REFERENCE_ID=$(az devcenter admin image show \
    --resource-group $RESOURCE_GROUP \
    --dev-center $DEV_CENTER_NAME \
    --gallery-name $PACKER_GALLERY_NAME \
    --name $image_name \
    --query id -o tsv)

    time az devcenter admin devbox-definition create \
    --name "${image_name}-definition-from-packer" \
    --dev-center $DEV_CENTER_NAME \
    --resource-group $RESOURCE_GROUP \
    --image-reference id=$PACKER_IMAGE_REFERENCE_ID \
    --os-storage-type $STORAGE_TYPE \
    --sku name="$SKU_NAME"
done