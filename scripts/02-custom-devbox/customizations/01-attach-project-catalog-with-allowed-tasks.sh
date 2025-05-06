PROJECT_TASK_CATALOG_NAME="project-customization-files"

az devcenter admin catalog create \
--name $TASK_CATALOG_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--git-hub path="allowed-tasks" branch="main" uri="https://github.com/0GiS0/azure-dev-center-demos.git" secret-identifier="https://$KEY_VAULT_NAME.vault.azure.net/secrets/$SECRET_NAME"

az devcenter admin catalog list \
-d $DEV_CENTER_NAME \
-g $RESOURCE_GROUP \
-o table


# az devcenter admin catalog-task list \
# --catalog-name $TASK_CATALOG_NAME \
# --dev-center $DEV_CENTER_NAME \
# --resource-group $RESOURCE_GROUP 


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
--git-hub path="project-customization-files" branch="main" uri="https://github.com/0GiS0/azure-dev-center-demos.git" secret-identifier="https://$KEY_VAULT_NAME.vault.azure.net/secrets/$SECRET_NAME"