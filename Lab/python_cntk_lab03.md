## Launch Batch Container using Azure Container Instances integrated with Azure Fileshare

### Lauch Azure Cloud Shell, using Bash session and download project files
1. From the Azure Portal, select the Cloud Shell ">_", or open a new tab and go to shell.azure.com
2. Make sure to select the proper directory/azure login
3. If accessing the Cloud Shell for the 1st time, follow the prompts to create an associated storage account, etc.
4. Git clone this repo into your home directory, than cd to the project root
```
git clone https://github.com/azure-appdev-tsp-ncr/a1day-python-cntk.git
cd a1day-python-cntk
 ```

### Create Storage Account and Initialize Fileshare Directories and Data
1. Use the provided Bash helper script to create a Storage Account, Fileshare, and upload project data
```
./a1day-init-fileshare.sh <Resource Group Name> <Location> <Storage Acct Prefix>

# Example: ./a1day-init-fileshare.sh a1day-cntk01 eastus a1daytst1
```
2. If ran successfully, output should look similar to the following
```
*** A1Day Python Storage Group
a1daytst2pycntk
{
  "accessTier": null,
  "creationTime": "2018-05-09T19:34:03.919166+00:00",
  "customDomain": null,
  "enableHttpsTrafficOnly": false,
  "encryption": {
    "keySource": "Microsoft.Storage",
    "keyVaultProperties": null,
    "services": {
      "blob": {
        "enabled": true,
        "lastEnabledTime": "2018-05-09T19:34:04.044168+00:00"
      },
      "file": {
        "enabled": true,
        "lastEnabledTime": "2018-05-09T19:34:04.044168+00:00"
      },
      "queue": null,
      "table": null
    }
  },
  "id": "/subscriptions/aa843008-1bae-4ffc-aa4c-5d65505c4a7c/resourceGroups/a1day-cntk01/providers/Microsoft.Storage/storageAccounts/a1daytst2pycntk",
  "identity": null,
  "kind": "Storage",
  "lastGeoFailoverTime": null,
  "location": "eastus",
  "name": "a1daytst2pycntk",
  "networkRuleSet": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://a1daytst2pycntk.blob.core.windows.net/",
    "file": "https://a1daytst2pycntk.file.core.windows.net/",
    "queue": "https://a1daytst2pycntk.queue.core.windows.net/",
    "table": "https://a1daytst2pycntk.table.core.windows.net/"
  },
  "primaryLocation": "eastus",
  "provisioningState": "Succeeded",
  "resourceGroup": "a1day-cntk01",
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "capabilities": null,
    "kind": null,
    "locations": null,
    "name": "Standard_LRS",
    "resourceType": null,
    "restrictions": null,
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
****************
Storage Acct: a1daytst2pycntk
Storage Key: cGzdTPVNDqBV4ea742igFF+1hzWUJvVDOLiPVdxG4ON71wCM76dBDbgxtapubUUPJ0lXmHj1yIGc3AwTuhX1bQ==
{
  "created": true
}
{
  "created": true
}
Finished[#############################################################]  100.0000%
{
  "created": true
}
****************
```
### Launch Batch Execution of Python/CNTK Container
1. Update Bash helper script ```a1day-python-aci.sh```, by using nanon
``` 
nano a1day-python-aci.sh
```
2. Scroll down to near end of script until you find the following section
```
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
```
3. update the ```--image``` argument with the ACR contaner repo image created in Lab 2, then remove the comments adding a line continuation and updating the registry command arguments similar to below
```
# Create A1Day Python/CNTK Server Container Instance
az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_CONTAINER_GROUP_NAME \
    --image a1daycntk01.azurecr.io/azureworkshop/a1day-python-cntk:v1 \
    --restart-policy Never \
    --environment-variables MODEL_RUN=$ACI_PERS_CONTAINER_GROUP_NAME \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /env \
    --registry-login-server a1daycntk01.azurecr.io \
    --registry-username a1daycntk01 \
    --registry-password mypassword1
```
4. Save and exit nano by using ```<cntrl> O``` and ```<cntrl> X```
