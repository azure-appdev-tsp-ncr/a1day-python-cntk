# bash script to execute az commands to launch a Python/CNTK Image using ACI, attaching an Azure Fileshare for
# data input and output. 
#
# Assumes az login already performed from Azure bash shell, and an existing resource group has been created
# Azure ACI will be used to create single container batch instance of Python/CNTK Image (must use supporting location)
# and mount an existing Azure Storage Account/Fileshare to container data volume.
#
# *** Use provided helper script 'a1day-init-fileshare.sh' to create Storage Account, Fileshare, and initialize data directories
# 
#  $1 - Resource Group Name
#  $2 - Resource Group location (e.g eastus)
#  $3 - ACI Container Prefix (Try to make unique, 8 char or less)
#  $4 - Storage Account Name
#   
#  Define Container Group, Storage Account & Fileshare  
ACI_PERS_RESOURCE_GROUP=$1
ACI_PERS_CONTAINER_GROUP_NAME=${3}${RANDOM}pycntk
ACI_PERS_LOCATION=$2
ACI_PERS_STORAGE_ACCOUNT_NAME=${4}
ACI_PERS_SHARE_NAME=pycntk
echo
echo '***' A1Day Python CNTK Container Group
echo $ACI_PERS_CONTAINER_GROUP_NAME

# Export the connection string as an environment variable. The following 'az storage' commands
# reference this environment variable.
export AZURE_STORAGE_CONNECTION_STRING=`az storage account show-connection-string --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --output tsv`

# Get and display Storage Account
STORAGE_ACCOUNT=$(az storage account list --resource-group $ACI_PERS_RESOURCE_GROUP --query "[?contains(name,'$ACI_PERS_STORAGE_ACCOUNT_NAME')].[name]" --output tsv)
echo '****************'
echo Storage Acct: $STORAGE_ACCOUNT
# Get and display Storage Key
STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)
echo Storage Key:  $STORAGE_KEY

# Create A1Day Python/CNTK Server Container Instance
az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_CONTAINER_GROUP_NAME \
    --image ghoelzer2azure/a1day-python-cntk:latest \
    --restart-policy Never \
    --environment-variables MODEL_RUN=$ACI_PERS_CONTAINER_GROUP_NAME \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /env
# Add continuation and uncomment/update for use with ACR
#    --registry-login-server mycontainerregistry.azurecr.io \
#    --registry-username <username> \
#    --registry-password <password1>

# Display created Container
echo '****************'
echo Launched Container: $ACI_PERS_CONTAINER_GROUP_NAME
# Attach to Container and Stream Sysout
echo '****************'
az container attach \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_CONTAINER_GROUP_NAME 
