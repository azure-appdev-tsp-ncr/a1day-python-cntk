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
