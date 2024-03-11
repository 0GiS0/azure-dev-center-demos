IMAGE_SOURCE=""
IMAGE_TEMPLATE_NAME="win11-with-eclipse"

az image builder create \
--name $IMAGE_TEMPLATE_NAME \
--resource-group $RESOURCE_GROUP \
--vm-size Standard_D2s_v3 \
--image-source $IMAGE_SOURCE \
--managed-image-destinations "image_1=$LOCATION" \
--shared-image-destinations $IMAGE_BUILDER_GALLERY_NAME/linux_image_def=westus,brazilsouth \
--identity $IMAGE_BUILDER_IDENTITY \
--scripts 