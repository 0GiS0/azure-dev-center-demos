DEV_CENTER_ID=$(az devcenter admin devcenter show \
--name $DEV_CENTER_NAME \
--resource-group $RESOURCE_GROUP \
--query id -o tsv)

for project_name in "${projects_names[@]}"
do
    gum style --foreground 212 "🏗️ Creating project $project_name"
    az devcenter admin project create \
    --name $project_name \
    --resource-group $RESOURCE_GROUP \
    --dev-center-id $DEV_CENTER_ID \
    --max-dev-boxes-per-user 2    

done

if [ "$group_names" != "" ]
then

    index=0

    for group_name in "${group_names[@]}"
    do
        gum style --foreground 212 "🔑 Give access to $group_name to all ${projects_names[$index]}" 

        ENTRA_ID_GROUP_ID=$(az ad group show --group "$group_name" --query id -o tsv)    
        
         az role assignment create \
        --role "DevCenter Dev Box User" \
        --assignee $ENTRA_ID_GROUP_ID \
        --scope $(az devcenter admin project show --name "${projects_names[$index]}" --resource-group $RESOURCE_GROUP --query id -o tsv)

        index=$((index+1))

    done
    gum style --foreground 212 "All projects have been created and access has been granted."
fi

# Delete all the projects (sometimes useful for testing 🥲)
# for project_name in "${projects_names[@]}"
# do
#     az devcenter admin project delete \
#     --name $project_name \
#     --resource-group $RESOURCE_GROUP \
#     --yes
# done

