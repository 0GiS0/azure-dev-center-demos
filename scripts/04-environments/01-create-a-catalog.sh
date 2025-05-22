# echo -e "Create an Azure Key Vault for the catalog"
# az keyvault create \
# --name $KEY_VAULT_NAME \
# --resource-group $RESOURCE_GROUP \
# --location $LOCATION

# DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
# --name $DEV_CENTER_NAME \
# --resource-group $RESOURCE_GROUP \
# --query identity.principalId -o tsv)

# az keyvault set-policy \
# --name $KEY_VAULT_NAME \
# --resource-group $RESOURCE_GROUP \
# --secret-permissions get \
# --object-id $DEV_CENTER_CLIENT_ID

# echo "Create a secret for GitHub PAT"
# az keyvault secret set \
# --vault-name $KEY_VAULT_NAME \
# --name $SECRET_NAME \
# --value $GITHUB_PAT

# echo -e "Get the secret identifier"
# SECRET_ID=$(az keyvault secret show \
# --name $SECRET_NAME \
# --vault-name $KEY_VAULT_NAME \
# --query id -o tsv)

az devcenter admin catalog create \
--name $CATALOG_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--git-hub path="infra-catalog" branch="main" uri="https://github.com/0GiS0/azure-dev-center-demos.git" secret-identifier="https://$KEY_VAULT_NAME.vault.azure.net/secrets/$SECRET_NAME"

az devcenter admin catalog list \
-d $DEV_CENTER_NAME \
-g $RESOURCE_GROUP \
-o table

az devcenter admin catalog get-sync-error-detail \
--name $CATALOG_NAME \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP

# az devcenter admin catalog show \
# --name $CATALOG_NAME \
# --dev-center $DEV_CENTER_NAME \
# --resource-group $RESOURCE_GROUP

DEV_CENTER_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query id -o tsv)

DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

# Dev Center identity must be Contributor of the subscription
az role assignment create \
--role "Contributor" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope "/subscriptions/$SUBSCRIPTION_ID"

az role assignment create \
--role "User Access Administrator" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope "/subscriptions/$SUBSCRIPTION_ID"

# Create a project for the catalog
az devcenter admin project create \
--name $PROJECT_FOR_ENVIRONMENTS \
--dev-center $DEV_CENTER_ID \
--resource-group $RESOURCE_GROUP


if $group_names != ""
then

    index=0

    for group_name in "${group_names[@]}"
    do
        ENTRA_ID_GROUP_ID=$(az ad group show --group "$group_name" --query id -o tsv)    
        
         az role assignment create \
        --role "DevCenter Dev Box User" \
        --assignee $ENTRA_ID_GROUP_ID \
        --scope $(az devcenter admin project show --name "$PROJECT_FOR_ENVIRONMENTS" --resource-group $RESOURCE_GROUP --query id -o tsv)

        index=$((index+1))

    done
fi


echo -e "Give access to your developers to this project" 

# Get the object id of the group
ENTRA_ID_GROUP_ID=$(az ad group show --group ${group_names[0]} --query id -o tsv)

az role assignment create \
--role "Deployment Environments User" \
--assignee $ENTRA_ID_GROUP_ID \
--scope $(az devcenter admin project show --name $PROJECT_FOR_ENVIRONMENTS \
--resource-group $RESOURCE_GROUP --query id -o tsv)

# Create environment type
az devcenter admin environment-type create \
--name $DEV_ENVIRONMENT_TYPE \
--dev-center $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP

# Get the role definition id for the Owner role
OWNER_ROLE_ID=$(az role definition list -n "Owner" --scope /subscriptions/$SUBSCRIPTION_ID --query '[].name' -o tsv)

# Assign the environment type to the project
az devcenter admin project-environment-type create \
--name $DEV_ENVIRONMENT_TYPE \
--resource-group $RESOURCE_GROUP \
--project-name $PROJECT_FOR_ENVIRONMENTS \
--roles "{\"$OWNER_ROLE_ID\":{}}" \
--identity-type "SystemAssigned" \
--deployment-target-id "/subscriptions/$SUBSCRIPTION_ID" \
--status "Enabled"