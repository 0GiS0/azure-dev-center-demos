projects_names=("tour-of-heroes-dotnet" "tour-of-heroes-java" "tour-of-heroes-python" "tour-of-heroes-containers")

DEV_CENTER_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query id -o tsv)

# Get the object id of the group
ENTRA_ID_GROUP_ID=$(az ad group show --group $ENTRA_ID_GROUP_NAME --query id -o tsv)

for project_name in "${projects_names[@]}"
do
    echo "Creating project $project_name"
    az devcenter admin project create \
    --name $project_name \
    --resource-group $RESOURCE_GROUP \
    --dev-center-id $DEV_CENTER_ID \
    --max-dev-boxes-per-user 2

    echo -e "Give access to your developers to this project" 

    az role assignment create \
    --role "DevCenter Dev Box User" \
    --assignee $ENTRA_ID_GROUP_ID \
    --scope $(az devcenter admin project show --name $project_name --resource-group $RESOURCE_GROUP --query id -o tsv)

done