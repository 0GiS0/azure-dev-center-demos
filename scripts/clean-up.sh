# # Delete all projects in projects names
# for project_name in "${projects_names[@]}"
# do
#     echo "Deleting project $project_name"
#     az devcenter admin project delete \
#     --name $project_name \
#     --resource-group $RESOURCE_GROUP --yes
# done

# az devcenter dev environment list \
# --project-name "qaenv" \
# --dev-center-name $RESOURCE_GROUP 

# DEV_ENVIRONMENT_TYPE="test"

# az devcenter admin environment-type list \
# --resource-group $RESOURCE_GROUP \
# --dev-center $DEV_CENTER_NAME

# az devcenter admin environment-type delete \
# --name "qatest" \
# --resource-group $RESOURCE_GROUP \
# --dev-center $DEV_CENTER_NAME --yes

# az devcenter dev environment list \
# --project-name "tour-of-heroes-environments" \
# --dev-center-name $DEV_CENTER_NAME \
# --user-id b73d8792-1dc4-407f-9be9-96f65f84e621

# # Delete 
# az devcenter admin project-environment-type delete \
# --name qatest \
# --resource-group $RESOURCE_GROUP \
# --project-name qaenv


# az devcenter admin environment-type list \
# --resource-group $RESOURCE_GROUP \
# --dev-center $DEV_CENTER_NAME \
# -o table

# # Delete environments before deleting the dev center
# az devcenter admin project-environment-type delete \
# --name "test" \
# --resource-group $RESOURCE_GROUP --project-name "tour-of-heroes-environments" 

# # Check environments
# az devcenter dev environment list \
# --project-name "tour-of-heroes-environments" \
# --dev-center-name $DEV_CENTER_NAME \
# --user-id "b73d8792-1dc4-407f-9be9-96f65f84e621"

time az group delete --name $RESOURCE_GROUP --yes

# Purge Azure Key Vault soft delete
az keyvault purge --name $KEY_VAULT_NAME --location $LOCATION

echo -e "Delete custom role"

az role definition delete \
--name "Azure Image Builder Service Image Creation Role" \
--scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/DevBoxDemos"

# az devcenter dev environment list \
# --project-name "qaenv" \
# --dev-center-name $DEV_CENTER_NAME

# az devcenter dev environment delete \
# --name "otromas" \
# --project-name "qaenv" \
# --dev-center-name $DEV_CENTER_NAME