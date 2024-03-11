echo -e "Deploy infra using Terraform"

cd packer-for-image-generation/terraform
terraform init
terraform apply -auto-approve

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

cd ..