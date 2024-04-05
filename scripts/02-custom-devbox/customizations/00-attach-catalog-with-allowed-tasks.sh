echo -e "Create an Azure Key Vault for the catalog"
az keyvault create \
--name $KEY_VAULT_NAME \
--resource-group $RESOURCE_GROUP \
--location $LOCATION

DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

az keyvault set-policy \
--name $KEY_VAULT_NAME \
--resource-group $RESOURCE_GROUP \
--secret-permissions get \
--object-id $DEV_CENTER_CLIENT_ID

echo "Create a secret for GitHub PAT"
az keyvault secret set \
--vault-name $KEY_VAULT_NAME \
--name $SECRET_NAME \
--value $GITHUB_PAT

echo -e "Get the secret identifier"
SECRET_ID=$(az keyvault secret show \
--name $SECRET_NAME \
--vault-name $KEY_VAULT_NAME \
--query id -o tsv)

az devcenter admin catalog create \
--name $CATALOG_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--git-hub path="allowed-tasks" branch="main" uri="https://github.com/0GiS0/azure-dev-box-demo.git" secret-identifier="https://$KEY_VAULT_NAME.vault.azure.net/secrets/$SECRET_NAME"

az devcenter admin catalog list \
-d $DEV_CENTER_NAME \
-g $RESOURCE_GROUP \
-o table