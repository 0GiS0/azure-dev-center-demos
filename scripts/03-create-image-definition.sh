echo -e "Creating image definition $IMAGE_DEF in Azure Compute Gallery $GALLERY_NAME"

az sig image-definition create \
--resource-group $RESOURCE_GROUP \
--gallery-name $GALLERY_NAME \
--gallery-image-definition "$IMAGE_DEF" \
--os-type "Windows" \
--os-state "Generalized" \
--publisher "returngis" \
--offer "vscodebox" \
--sku "1-0-0" \
--hyper-v-generation "V2" \
--features "SecurityType=TrustedLaunch"