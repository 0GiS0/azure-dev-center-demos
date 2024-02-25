IMAGE_SOURCE=""
IMAGE_TEMPLATE_NAME="win11-with-eclipse"

az image builder create \
--name $IMAGE_TEMPLATE_NAME \
--resource-group $RESOURCE_GROUP \
--vm-size Standard_D2s_v3 \
--image-source $IMAGE_SOURCE \
--managed-image-destinations "image_1=westus2 image_2=westus" \
--shared-image-destinations my_shared_gallery/linux_image_def=westus,brazilsouth \
--identity myIdentity \
--scripts 