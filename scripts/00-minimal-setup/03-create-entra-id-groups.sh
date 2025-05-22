for group_name in "${group_names[@]}"
do
    # Display progress with gum spin
    group_id=$(gum spin --title "🔍 Checking if group $group_name exists..." -- az ad group show --group "$group_name" --query id -o tsv 2>/dev/null || echo "")

    if [ -z "$group_id" ]
    then
        gum style --foreground 212 "✨ Creating group $group_name"
        az ad group create --display-name "$group_name" --mail-nickname "$group_name"
        gum style --foreground 46 "✅ Group $group_name created successfully"
    else
        gum style --foreground 226 "ℹ️  Group $group_name already exists"
    fi
        
done