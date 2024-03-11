echo -e "Deploy infra using Terraform"

cd packer-for-image-generation/terraform
terraform init
terraform apply -auto-approve

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac --name hcp-packer --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID

echo -e "Build images using Packer"

cd ..

image_names=("vscode" "eclipse" "jetbrains")

for image_name in "${image_names[@]}"
do

    echo "Building $image_name image"
    cd $image_name  

    packer init .

    packer build -force . 

    echo "Going back to the root directory"
    cd ..

done