#!/bin/bash

echo -e "Creating Azure Image Builder identity $IMAGE_BUILDER_IDENTITY 🛠️"

IDENTITY_CLIENT_ID=$(az identity create \
--name $IMAGE_BUILDER_IDENTITY \
--resource-group $RESOURCE_GROUP \
--query clientId -o tsv)

gum spin --spinner dot --title "Waiting 30 seconds for the identity to be created 🕒" -- sleep 30

gum style --foreground 212 --bold "Assigning role to Azure Image Builder identity $IMAGE_BUILDER_IDENTITY 🔑"


az role definition create --role-definition @- <<EOF
{
  "Name": "Azure Image Builder Service Image Creation Role",
  "IsCustom": true,
  "Description": "Image Builder access to create resources for the image build, you should delete or split out as appropriate",
  "Actions": [
    "Microsoft.Compute/galleries/read",
    "Microsoft.Compute/galleries/images/read",
    "Microsoft.Compute/galleries/images/versions/read",
    "Microsoft.Compute/galleries/images/versions/write",

    "Microsoft.Compute/images/write",
    "Microsoft.Compute/images/read",
    "Microsoft.Compute/images/delete",
    
    "Microsoft.Network/*",

    "Microsoft.Storage/*",

    "Microsoft.ContainerInstance/*"
  ],
  "NotActions": [
  
  ],
  "AssignableScopes": [
    "/subscriptions/$SUBSCRIPTION_ID"
  ]
  }
EOF

gum style --foreground 212 --bold "Checking if the custom role was created successfully 🎉"

az role definition list --custom-role-only -o table

gum style --foreground 212 --bold "Assigning the custom role to the Azure Image Builder identity $IMAGE_BUILDER_IDENTITY 🔑"

az role assignment create \
--role "Azure Image Builder Service Image Creation Role" \
--assignee $IDENTITY_CLIENT_ID \
--scope $(az sig show --gallery-name $IMAGE_BUILDER_GALLERY_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)

gum style --foreground 212 --bold "Verify permissions of $IMAGE_BUILDER_IDENTITY 🔑"

az role assignment list \
--assignee $IDENTITY_CLIENT_ID \
--query "[].{role:roleDefinitionName, scope:scope}" --all -o table 