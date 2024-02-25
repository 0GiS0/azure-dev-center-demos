echo -e "Create $DEV_CENTER_PROJECT project in $DEV_CENTER_NAME"

az devcenter admin project create \
--name $DEV_CENTER_PROJECT \
--resource-group $RESOURCE_GROUP \
--dev-center-id $DEV_CENTER_ID \
--max-dev-boxes-per-user 2

echo -e "Give access to your developers to this project" 

az role assignment create \
--role "DevCenter Dev Box User" \
--assignee $USER_EMAIL \
--scope $(az devcenter admin project show --name $DEV_CENTER_PROJECT --resource-group $RESOURCE_GROUP --query id -o tsv)