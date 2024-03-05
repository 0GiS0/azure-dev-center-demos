# DEV_BOX_POOL_NAME_WITH_PACKER_IMAGE="dev-box-pool-with-packer-image"

project_names=("tour-of-heroes-dotnet" "tour-of-heroes-java" "tour-of-heroes-python")
image_names=("vscode_with_extensions" "eclipse" "jetbrains")

index=1

for project_name in "${projects_names[@]}"
do
    
    echo "Creating dev box pool ${project_name}_pool for $project_name"
    echo "Defining dev box definition for $image_names[$index]_box"
    
    time az devcenter admin pool create \
    --name "${project_name}_pool" \
    --project-name $project_name \
    --resource-group $RESOURCE_GROUP \
    --devbox-definition-name ${image_names[$index]}_box \
    --local-administrator Enabled \
    --virtual-network-type Managed \
    --managed-virtual-network-regions $LOCATION

    index=$((index+1))
done

# az devcenter admin pool create \
# --name $DEV_BOX_POOL_NAME_WITH_PACKER_IMAGE \
# --project-name $DEV_CENTER_PROJECT \
# --resource-group $RESOURCE_GROUP \
# --devbox-definition-name $DEV_BOX_DEFINITION_NAME_FOR_PACKER_IMAGES \
# --local-administrator Enabled \
# --virtual-network-type Managed \
# --managed-virtual-network-regions $LOCATION 
