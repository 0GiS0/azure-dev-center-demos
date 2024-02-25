mkdir -p tmp
cp custom-images/win11-with-vscode.json tmp/win11-with-vscode.json

sed -i -e "s%<subscriptionID>%$SUBSCRIPTION_ID%g" tmp/win11-with-vscode.json
sed -i -e "s%<rgName>%$RESOURCE_GROUP%g" tmp/win11-with-vscode.json
sed -i -e "s%<region1>%$LOCATION%g" tmp/win11-with-vscode.json
sed -i -e "s%<runOutputName>%$RUN_OUTPUT_NAME%g" tmp/win11-with-vscode.json
sed -i -e "s%<sharedImageGalName>%$GALLERY_NAME%g" tmp/win11-with-vscode.json
sed -i -e "s%<imgBuilderId>%$IDENTITY_ID%g" tmp/win11-with-vscode.json
sed -i -e "s%<imageDefName>%$IMAGE_DEF%g" tmp/win11-with-vscode.json


echo -e "This template needs some parameters so let's create a parameters file"

cat <<EOF > tmp/win11-with-vscode-parameters.json
{
  "imageTemplateName": {
    "value": "$IMAGE_TEMPLATE"
  },
  "api-version": {
    "value": "2020-02-14"
  },
  "svclocation": {
    "value": "$LOCATION"
  }
}
EOF

echo -e "And now let's create the Image Template using this ARM template 😁"

az group deployment create \
--resource-group $RESOURCE_GROUP \
--template-file tmp/win11-with-vscode.json \
--parameters @tmp/win11-with-vscode-parameters.json

echo -e "We have the image template but now we need to create an image inside the gallery. Let's run Azure Image Builder to create it"

az image builder run \
--name $IMAGE_TEMPLATE \
--resource-group $RESOURCE_GROUP