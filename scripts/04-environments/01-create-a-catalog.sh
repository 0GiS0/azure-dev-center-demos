echo -e "Create an Azure Key Vault for the catalog"
az keyvault create \
--name "${DEV_CENTER_NAME}kv" \
--resource-group $RESOURCE_GROUP \
--location $LOCATION

echo "Let's assign the Contributor role to the Dev Center for the key vault"
az role assignment create \
--role "Contributor" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope $(az keyvault show --name "${DEV_CENTER_NAME}kv" --resource-group $RESOURCE_GROUP --query id -o tsv)

echo "Create a secret for GitHub PAT"
az keyvault secret set \
--vault-name "${DEV_CENTER_NAME}kv" \
--name "github-pat" \
--value $GITHUB_PAT

echo -e "Get the secret identifier"
SECRET_ID=$(az keyvault secret show \
--name "github-pat" \
--vault-name "${DEV_CENTER_NAME}kv" \
--query id -o tsv)

CATALOG_NAME="tour-of-heroes-catalog"

az devcenter admin catalog create \
--name $CATALOG_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--git-hub path="/catalog" branch="main" uri="https://github.com/0GiS0/azure-dev-box-demo.git"  \
secret-identifier="$SECRET_ID" \
--sync-type "Manual"

az devcenter admin catalog get-sync-error-detail \
--name $CATALOG_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP

az devcenter admin catalog show \
--name quickstart \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP
