# bash script to execute az commands to create a simple Cloud SFTP Server/Azure Fileshare deployment
#
# Assumes az login already performed from Azure bash shell, and an existing resource group has been created
# Azure ACI will be used to create single container/SFTP Server (must use supporting location)
# and create and mount Azure Storage Account/Fileshare to container data volume
# 
# Use provided script <tbd.sh> to create resource group/fileshare pair
#
#  $1 - Resource Group Name
#  $2 - Resource Group location (e.g eastus)
#  $3 - SFTP Server DNS Label Prefix (Try to make unique, 8 char or less)
#  $4 - SFTP User Name
#  $5 - SFTP User Base Directory (will be created)
#
#  Trying to ensure Linux compatability
#   
#  Create Storage Account & Fileshare  
ACI_PERS_RESOURCE_GROUP=$1
ACI_PERS_CONTAINER_GROUP_NAME=${3}${RANDOM}sftp
ACI_PERS_LOCATION=$2
#ACI_PERS_SHARE_NAME=tbd
echo
echo '***' A1Day Python CNTK Container Group
echo $ACI_PERS_CONTAINER_GROUP_NAME

# Export the connection string as an environment variable. The following 'az storage share create' command
# references this environment variable when creating the Azure file share.
# export AZURE_STORAGE_CONNECTION_STRING=`az storage account show-connection-string --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --output tsv`

# Get and display Storage Account
#STORAGE_ACCOUNT=$(az storage account list --resource-group $ACI_PERS_RESOURCE_GROUP --query "[?contains(name,'$ACI_PERS_STORAGE_ACCOUNT_NAME')].[name]" --output tsv)
#echo '****************'
#echo Storage Acct: $STORAGE_ACCOUNT
# Get and display Storage Key
#STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)
#echo Storage Key:  $STORAGE_KEY

# Create A1Day CNTK Server Container Instance
az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_CONTAINER_GROUP_NAME \
    --image ghoelzer2azure/a1day-python-cntk:latest
# Additional Parms to Mount Fileshare
#    --environment-variables SFTP_USERS=$4:$SFTP_PWD \
#    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
#    --azure-file-volume-account-key $STORAGE_KEY \
#    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
#    --azure-file-volume-mount-path /home/$4/$5

# Display created Container
echo '****************'
echo Launched Container: $ACI_PERS_CONTAINER_GROUP_NAME
# Attach to Container and Stream Sysout
echo '****************'
az container attach \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_CONTAINER_GROUP_NAME 