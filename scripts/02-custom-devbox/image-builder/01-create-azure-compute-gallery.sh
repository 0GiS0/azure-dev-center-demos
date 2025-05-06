gum style --foreground 212 "📸 Creating Azure Compute Gallery $IMAGE_BUILDER_GALLERY_NAME in $LOCATION"

az sig create \
--resource-group $RESOURCE_GROUP \
--gallery-name $IMAGE_BUILDER_GALLERY_NAME \
--location $LOCATION

echo "✅ $(gum style --foreground 46 "Azure Compute Gallery created successfully")"
gum style --foreground 212 "🔑 Assigning the Contributor role to the Dev Center for the gallery"

DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

az role assignment create \
--role "Contributor" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope $(az sig show --gallery-name $IMAGE_BUILDER_GALLERY_NAME \
--resource-group $RESOURCE_GROUP --query id -o tsv)

echo "✅ $(gum style --foreground 46 "Role assignment created successfully")"


gum style --foreground 212 "🔗 Linking the Azure Compute Gallery to the Dev Center"

az devcenter admin gallery create \
--name $IMAGE_BUILDER_GALLERY_NAME \
--gallery-resource-id $(az sig show --gallery-name $IMAGE_BUILDER_GALLERY_NAME --resource-group $RESOURCE_GROUP --query id -o tsv) \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP