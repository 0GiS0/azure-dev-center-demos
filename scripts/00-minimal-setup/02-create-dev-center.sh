
echo -e "Creating Dev Center $DEV_CENTER_NAME"

DEV_CENTER_ID=$(az devcenter admin devcenter create \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--identity-type "SystemAssigned" \
--query id -o tsv)

DEV_CENTER_CLIENT_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query identity.principalId -o tsv)

# Assign the Contributor role to the Dev Center
# If you don't have the role, you can't deploy environments
az role assignment create \
--role "Contributor" \
--assignee $DEV_CENTER_CLIENT_ID \
--scope /subscriptions/$SUBSCRIPTION_ID