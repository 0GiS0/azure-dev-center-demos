# If some command fails, the script will stop executing
# and the error will be printed to the console
# This is useful for debugging and ensuring that the script runs correctly
# set -e                                                                                                                                                                                                                                                                                                                                                                                                                                             qqqq    

# Assign identity to the project
az devcenter admin project update \
--name $PROJECT_FOR_ENVIRONMENTS \
--resource-group $RESOURCE_GROUP \
--identity-type SystemAssigned

# Get object id of the project
PROJECT_OBJ_ID=$(az devcenter admin project show \
--name $PROJECT_FOR_ENVIRONMENTS \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

az keyvault set-policy \
--name $KEY_VAULT_NAME \
--resource-group $RESOURCE_GROUP \
--secret-permissions get \
--object-id $PROJECT_OBJ_ID


az devcenter admin project-catalog create \
--name $PROJECT_TASK_CATALOG_NAME \
--project $PROJECT_FOR_ENVIRONMENTS \
--resource-group $RESOURCE_GROUP \
--git-hub path="team-customization-files" branch="main" uri="https://github.com/0GiS0/azure-dev-center-demos.git" secret-identifier="https://$KEY_VAULT_NAME.vault.azure.net/secrets/$SECRET_NAME"


# Get the names of the images definitions we have in the project
IMAGE_DEFINITIONS=$(az devcenter admin project-image-definition list \
    --project-name "$PROJECT_FOR_ENVIRONMENTS" \
    --catalog-name "$PROJECT_TASK_CATALOG_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "[].{Name:name}" -o tsv)


echo "Image Definitions: $IMAGE_DEFINITIONS"

# For each image definition, get the image reference id
for IMAGE_DEFINITION_NAME in $IMAGE_DEFINITIONS; do
   
    az devcenter admin pool create \
    --location $LOCATION \
    --network-connection-name "$VNET_NAME-attached-network" \
    --pool-name "$IMAGE_DEFINITION_NAME-pool" \
    --project-name "$PROJECT_FOR_ENVIRONMENTS" \
    --resource-group $RESOURCE_GROUP \
    --local-administrator "Enabled" \
    --virtual-network-type "Unmanaged" \
    --single-sign-on-status "Enabled" \
    --devbox-definition-type "Value" \
    --devbox-definition-image-reference id="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.DevCenter/projects/$PROJECT_FOR_ENVIRONMENTS/images/~Catalog~$PROJECT_TASK_CATALOG_NAME~$IMAGE_DEFINITION_NAME" \
    --devbox-definition-sku name="$SKU_NAME"

done


az devcenter admin pool list \
--project-name "$PROJECT_FOR_ENVIRONMENTS" \
--resource-group $RESOURCE_GROUP \
--output table


