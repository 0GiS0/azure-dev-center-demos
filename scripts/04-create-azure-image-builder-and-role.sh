echo -e "Creating Azure Image Builder identity $IMAGE_BUILDER_IDENTITY"

IDENTITY_CLIENT_ID=$(az identity create \
--name $IMAGE_BUILDER_IDENTITY \
--resource-group $RESOURCE_GROUP \
--query clientId -o tsv)

echo -e "Assigning role to Azure Image Builder identity $IMAGE_BUILDER_IDENTITY"

az role definition create --role-definition @- <<EOF
{
    "Name": "Azure Image Builder Service Image Creation Role 2",
    "IsCustom": true,
    "Description": "Image Builder access to create resources for the image build, you should delete or split out as appropriate",
    "Actions": [
        "Microsoft.Compute/galleries/read",
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/images/versions/read",
        "Microsoft.Compute/galleries/images/versions/write",

        "Microsoft.Compute/images/write",
        "Microsoft.Compute/images/read",
        "Microsoft.Compute/images/delete"
    ],
    "NotActions": [
  
    ],
    "AssignableScopes": [
      "/subscriptions/$SUBSCRIPTION_ID"
    ]
  }
EOF

echo -e "Check the custom role was created successfully 🎉"

az role definition list --custom-role-only -o table

echo -e "Assign the custom role to the identity $IMAGE_BUILDER_IDENTITY"

az role assignment create \
--role "Azure Image Builder Service Image Creation Role 2" \
--assignee $IDENTITY_CLIENT_ID \
--scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP

echo -e "Check the role was assigned successfully ✅"

az role assignment list --assignee $IDENTITY_CLIENT_ID --all -o table

IDENTITY_ID=$(az identity show --name $IMAGE_BUILDER_IDENTITY --resource-group $RESOURCE_GROUP --query id -o tsv)
