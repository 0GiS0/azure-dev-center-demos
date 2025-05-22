echo -e "🚀 Creating resource group $RESOURCE_GROUP in $LOCATION" | gum format --theme=pink

az group create \
--name $RESOURCE_GROUP \
--location $LOCATION

gum spin --spinner dot --title "✨ Resource group creation in progress..." -- sleep 1
gum style --foreground 2 "✅ Resource group $RESOURCE_GROUP successfully created!"