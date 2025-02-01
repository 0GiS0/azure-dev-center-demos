# az ad group create --display-name $ENTRA_ID_GROUP_NAME --mail-nickname $ENTRA_ID_GROUP_NAME
#

for group_name in "${group_names[@]}"
do

    # Check if the group exists
    group_id=$(az ad group show --group $group_name --query id -o tsv)

    if [ -z "$group_id" ]
    then
        echo "Creating group $group_name"
        az ad group create --display-name "$group_name" --mail-nickname "$group_name"
    else
        echo "Group $group_name already exists"
    fi
        
done