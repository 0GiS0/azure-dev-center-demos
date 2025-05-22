gum style --foreground 212 --bold "The easiest way to generate the template is using this assistant:"
gum style --italic "https://portal.azure.com/#create/Microsoft.ImageTemplate"

mkdir -p tmp
cp custom-images/win11-with-vscode.json tmp/win11-with-vscode.json

sed -i -e "s%<subscriptionID>%$SUBSCRIPTION_ID%g" tmp/win11-with-vscode.json
sed -i -e "s%<rgName>%$RESOURCE_GROUP%g" tmp/win11-with-vscode.json
sed -i -e "s%<region1>%$LOCATION%g" tmp/win11-with-vscode.json
sed -i -e "s%<runOutputName>%$VSCODE_RUN_OUTPUT_NAME%g" tmp/win11-with-vscode.json
sed -i -e "s%<sharedImageGalName>%$IMAGE_BUILDER_GALLERY_NAME%g" tmp/win11-with-vscode.json
sed -i -e "s%<imgBuilderId>%$IDENTITY_ID%g" tmp/win11-with-vscode.json
sed -i -e "s%<imageDefName>%$VSCODE_IMAGE_DEFINITION%g" tmp/win11-with-vscode.json

gum style --foreground 212 --bold "This template needs some parameters so let's create a parameters file"

cat <<EOF > tmp/win11-with-vscode-parameters.json
{
  "imageTemplateName": {
    "value": "$VSCODE_IMAGE_TEMPLATE"
  },
  "api-version": {
    "value": "2020-02-14"
  },
  "svclocation": {
    "value": "$LOCATION"
  }
}
EOF

gum style --foreground 212 --bold "And now let's create the Image Template using this ARM template 😁"

az group deployment create \
--resource-group $RESOURCE_GROUP \
--template-file tmp/win11-with-vscode.json \
--parameters @tmp/win11-with-vscode-parameters.json

gum style --foreground 212 --bold "We have the image template but now we need to create an image inside the gallery."
gum style --foreground 212 --bold "Let's run Azure Image Builder to create it"

time az image builder run \
--name $VSCODE_IMAGE_TEMPLATE \
--resource-group $RESOURCE_GROUP