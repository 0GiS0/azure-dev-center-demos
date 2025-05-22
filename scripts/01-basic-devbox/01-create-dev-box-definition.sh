# Show what we're about to do
echo "🔍 $(gum style --foreground 212 "Finding Visual Studio image in Dev Center gallery...")"

IMAGE_REFERENCE_ID=$(az devcenter admin image show \
--resource-group $RESOURCE_GROUP \
--dev-center $DEV_CENTER_NAME \
--gallery-name Default \
--name "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2" \
--query id -o tsv)

echo "✅ $(gum style --foreground 46 "Image found successfully")"
echo "🛠️ $(gum style --foreground 212 "Creating DevBox definition: '$DEV_BOX_DEFINITION_FOR_BASIC_DEMO'")"
echo "   $(gum style --faint "Using SKU: $SKU_NAME with $STORAGE_TYPE storage")"

time az devcenter admin devbox-definition create \
--name $DEV_BOX_DEFINITION_FOR_BASIC_DEMO \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--image-reference id=$IMAGE_REFERENCE_ID \
--os-storage-type $STORAGE_TYPE \
--sku name="$SKU_NAME" \
--hibernate-support Enabled

echo "✅ $(gum style --foreground 46 "DevBox definition created successfully")"