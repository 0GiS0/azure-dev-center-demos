# Using this Terraform

## Variables

1. Copy or rename the terraforms.tfvars.example file
2. Enter the required values (e.g. ```subscription_id``` required by the ```azurerm``` provider)

## Executing the command

From the repo root

```bash
cd terraform
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## Notes

### Packer and custom images

While we include a way to build a custom image in a single Terraform module using the [terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data) resource type and [local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec) provisioner, this is not an ideal path to do so outside of this demo as it would be better suited to be in its own GitHub Actions Workflow or other CI/CD process to create and version the image.  Ideally custom images are in a "mono repo" that contains all custom image definitions and environments that they should deploy to, and you would need to provide the targetted::

- Dev Center ID
- Dev Center Gallery ID
- Image Name (Same as the azurerm_shared_image.$identifier.name )

### Clean up

For the demo itself the easiest path is to run ```az group delete -n $RG_NAME``` instead of ```terraform destroy``` as there are dependent resources created that were generated outside of Terraform and therefore Terraform has no ability to remove these child/dependent resources.  As an example, the custom image versions created with Packer, since they were generated with the terraform_data resource as a wrapper, are technically outside of Terraforms normal resource lifecycle.
