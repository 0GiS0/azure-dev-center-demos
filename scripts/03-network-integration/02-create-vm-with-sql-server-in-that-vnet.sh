# SQL Server VM on Azure
DB_VM_NAME="db-vm"
DB_VM_IMAGE="MicrosoftSQLServer:sql2022-ws2022:sqldev-gen2:16.0.230613"
DB_VM_ADMIN_USERNAME="dbadmin"
DB_VM_ADMIN_PASSWORD="Db@dmin123@@"
DB_VM_NSG_NAME="db-vm-nsg"
VM_SIZE="Standard_B2s"
STORAGE_ACCOUNT_NAME="dbstore$RANDOM"

az vm create \
--resource-group $RESOURCE_GROUP \
--name $DB_VM_NAME \
--image $DB_VM_IMAGE \
--admin-username $DB_VM_ADMIN_USERNAME \
--admin-password $DB_VM_ADMIN_PASSWORD \
--vnet-name $VNET_NAME \
--subnet $DB_SUBNET_NAME \
--public-ip-address "" \
--size $VM_SIZE \
--nsg $DB_VM_NSG_NAME 

echo -e "Create a storage acount $STORAGE_ACCOUNT_NAME for the backups"
az storage account create \
--name $STORAGE_ACCOUNT_NAME \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--sku Standard_LRS \
--kind StorageV2

STORAGE_KEY=$(az storage account keys list \
--resource-group $RESOURCE_GROUP \
--account-name $STORAGE_ACCOUNT_NAME \
--query "[0].value" \
--output tsv)

echo -e "Add SQL Server extension to the database vm"
az sql vm create \
--name $DB_VM_NAME \
--license-type payg \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--connectivity-type PRIVATE \
--port 1433 \
--sql-auth-update-username $DB_VM_ADMIN_USERNAME \
--sql-auth-update-pwd $DB_VM_ADMIN_PASSWORD \
--backup-schedule-type manual \
--full-backup-frequency Weekly \
--full-backup-start-hour 2 \
--full-backup-duration 2 \
--storage-account "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/" \
--sa-key $STORAGE_KEY \
--retention-period 30 \
--log-backup-frequency 60

echo -e "Database vm created"

echo -e "Create a network security group rule for SQL Server port 1433"
az network nsg rule create \
--resource-group $RESOURCE_GROUP \
--nsg-name $DB_VM_NSG_NAME \
--name AllowSQLServer \
--priority 1001 \
--destination-port-ranges 1433 \
--protocol Tcp \
--source-address-prefixes "*" \
--direction Inbound
