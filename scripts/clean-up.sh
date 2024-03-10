time az group delete --name $RESOURCE_GROUP --yes

# Purge Azure Key Vault soft delete
az keyvault purge --name $KEY_VAULT_NAME --location $LOCATION

echo -e "Delete custom role"

az role definition delete \
--name "Azure Image Builder Service Image Creation Role" \
--scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/DevBoxDemos"