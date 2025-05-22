echo -e "Deploy infra using Terraform"

cd packer-for-image-generation/terraform
terraform init
terraform apply \
-var="subscription_id=$SUBSCRIPTION_ID" \
-var="location=$LOCATION" \
-var="resource_group_name=$PACKER_GALLERY_RESOURCE_GROUP" \
-var="packer_image_gallery_name=$PACKER_GALLERY_NAME" \
-auto-approve

echo -e "Build images using Packer"

cd ..


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