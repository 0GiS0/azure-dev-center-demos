echo -e "Create Azure Container Registry"

ACR_NAME="dragonstoneacr"

az acr create \
--name $ACR_NAME \
--resource-group $RESOURCE_GROUP \
--sku Basic \
--admin-enabled true

echo -e "Build the image in the ACR"

az acr build \
--registry $ACR_NAME \
--image "ade:{{.Run.ID}}" \
--file "scripts/04-environments/ade-extensibility-model-terraform/Dockerfile" \
"scripts/04-environments/ade-extensibility-model-terraform"

echo -e "Assign AcrPull role to the the name of the project environment type that needs to access the image in the container."

az role assignment create \
--role "AcrPull" \
--assignee

