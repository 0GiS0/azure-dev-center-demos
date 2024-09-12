index=0

for project_name in "${projects_names[@]}"
do
    
    echo "Creating dev box pool ${image_names[0]}-pool for $project_name"
    echo "Defining dev box definition for ${image_names[$index]}-definition-from-packer"
    
    time az devcenter admin pool create \
    --name "${image_names[0]}-pool" \
    --project-name $project_name \
    --resource-group $RESOURCE_GROUP \
    --devbox-definition-name ${image_names[0]}-definition-from-packer \
    --local-administrator Enabled \
    --virtual-network-type Managed \
    --managed-virtual-network-regions $LOCATION

    index=$((index+1))
done