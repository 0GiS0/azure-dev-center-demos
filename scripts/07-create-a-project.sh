projects_names=("tour-of-heroes-dotnet" "tour-of-heroes-java" "tour-of-heroes-python")

# echo -e "Create $DEV_CENTER_PROJECT project in $DEV_CENTER_NAME"

DEV_CENTER_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query id -o tsv)

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
    --assignee $USER_EMAIL \
    --scope $(az devcenter admin project show --name $project_name --resource-group $RESOURCE_GROUP --query id -o tsv)

done

# az devcenter admin project create \
# --name $DEV_CENTER_PROJECT \
# --resource-group $RESOURCE_GROUP \
# --dev-center-id $DEV_CENTER_ID \
# --max-dev-boxes-per-user 2

# echo -e "Give access to your developers to this project" 

# az role assignment create \
# --role "DevCenter Dev Box User" \
# --assignee $USER_EMAIL \
# --scope $(az devcenter admin project show --name $DEV_CENTER_PROJECT --resource-group $RESOURCE_GROUP --query id -o tsv)