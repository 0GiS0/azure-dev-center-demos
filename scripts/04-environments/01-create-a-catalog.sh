echo -e "Create an Azure Key Vault for the catalog"
az keyvault create \
--name $KEY_VAULT_NAME \
--resource-group $RESOURCE_GROUP \
--location $LOCATION

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
--git-hub path="catalog" branch="main" uri="https://github.com/0GiS0/azure-dev-box-demo.git" secret-identifier="https://$KEY_VAULT_NAME.vault.azure.net/secrets/$SECRET_NAME"

# az devcenter admin catalog get-sync-error-detail \
# --name $CATALOG_NAME \
# --dev-center $DEV_CENTER_NAME \
# --resource-group $RESOURCE_GROUP

# az devcenter admin catalog show \
# --name $CATALOG_NAME \
# --dev-center $DEV_CENTER_NAME \
# --resource-group $RESOURCE_GROUP

# Create a project for the catalog
az devcenter admin project create \
--name $PROJECT_FOR_ENVIRONMENTS \
--dev-center $DEV_CENTER_ID \
--resource-group $RESOURCE_GROUP

echo -e "Give access to your developers to this project" 

az role assignment create \
--role "Deployment Environments User" \
--assignee $USER_EMAIL \
--scope $(az devcenter admin project show --name $PROJECT_FOR_ENVIRONMENTS --resource-group $RESOURCE_GROUP --query id -o tsv)

# Create environment type
az devcenter admin environment-type create \
--name $DEV_ENVIRONMENT_TYPE \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP

# Assign the environment type to the project
az devcenter admin project-environment-type create \
--name $DEV_ENVIRONMENT_TYPE \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--project-name $PROJECT_FOR_ENVIRONMENTS \
--roles "{\"4cbf0b6c-e750-441c-98a7-10da8387e4d6\":{}}" \
--identity-type "SystemAssigned" \
--deployment-target-id $SUBSCRIPTION_ID \
--status "Enabled"