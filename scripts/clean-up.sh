time az group delete --name $RESOURCE_GROUP --yes

echo -e "Delete custom role"

az role definition delete \
--name "Azure Image Builder Service Image Creation Role" \
--scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/DevBoxDemos"