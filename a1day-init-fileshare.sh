# bash script to execute az commands to create a Storage Account, Azure Fileshare, and initialize Data Directories
#
# Assumes az login already performed from Azure bash shell, an existing resource group has been created, and this
# script is executed from the root of this cloned Git repo.
# 
#  $1 - Resource Group Name
#  $2 - Resource Group location (e.g eastus)
#  $3 - Storage Account Prefix (Try to make unique, 8 char or less)
#   
#  Create Storage Account & Fileshare  
ACI_PERS_RESOURCE_GROUP=$1
ACI_PERS_STORAGE_ACCOUNT_NAME=${3}pycntk
ACI_PERS_LOCATION=$2
ACI_PERS_SHARE_NAME=pycntk
echo
echo '***' A1Day Python Storage Group
echo $ACI_PERS_STORAGE_ACCOUNT_NAME

# Create the storage account with the parameters
az storage account create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --location $ACI_PERS_LOCATION \
--sku Standard_LRS

# Export the connection string as an environment variable. The following 'az storage' commands
# reference this environment variable when creating the Azure file share.
export AZURE_STORAGE_CONNECTION_STRING=`az storage account show-connection-string --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --output tsv`

# Get and display Storage Account
STORAGE_ACCOUNT=$(az storage account list --resource-group $ACI_PERS_RESOURCE_GROUP --query "[?contains(name,'$ACI_PERS_STORAGE_ACCOUNT_NAME')].[name]" --output tsv)
echo '****************'
echo Storage Acct: $STORAGE_ACCOUNT
# Get and display Storage Key
STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)
echo Storage Key:  $STORAGE_KEY

# Create Fileshare
az storage share create \
    --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --account-key $STORAGE_KEY \
    --name $ACI_PERS_SHARE_NAME

# Create Data Directory & Upload Data
az storage directory create \
   --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
   --account-key $STORAGE_KEY \
   --share-name $ACI_PERS_SHARE_NAME \
   --name "Data"

az storage file upload \
    --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --account-key $STORAGE_KEY \
    --share-name $ACI_PERS_SHARE_NAME \
    --source "./Data/cleveland_cntk_twonode.txt" \
    --path "Data/cleveland_cntk_twonode.txt"

# Create Model Output Directory
az storage directory create \
   --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
   --account-key $STORAGE_KEY \
   --share-name $ACI_PERS_SHARE_NAME \
   --name "Model"

echo '****************'
echo Storage Initialization complete for $ACI_PERS_STORAGE_ACCOUNT_NAME/$ACI_PERS_SHARE_NAME
