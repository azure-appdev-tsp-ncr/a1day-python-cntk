## Launch Batch Container using Azure Container Instances integrated with Azure Fileshare

### Lauch Azure Cloud Shell, using Bash session and download project files
1. From the Azure Portal, select the Cloud Shell ">_", or open a new tab and go to shell.azure.com
2. Make sure to select the proper directory/azure login
3. If accessing the Cloud Shell for the 1st time, follow the prompts to create an associated storage account, etc.
4. Git clone this repo into your home directory, then cd to the project root
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
3. Noting the full **Storage Account Name** created above, go back the Azure Portal, select the Storage Account within the associated Resource Group.  You should then be able to review the created Fileshare, noting the Data and Model directories created, and data file uploaded to the Data directory.

### Launch Batch Execution of Python/CNTK Container
1. Update Bash helper script ```a1day-python-aci.sh```, by using nano
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
3. update the ```--image``` argument with the ACR container repo image created in Lab 2, then remove the comments and adding a line continuation, updating the registry command arguments similar to below
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

5. Execute the Bash ACI Container Launch script, which will create a unique container instance per script execution
```
./a1day-init-fileshare.sh <Resource Group Name> <Location> <Container Group Prefix> <Storage Acct Name>

# Example: ./a1day-python-aci.sh a1day-cntk01 eastus a1day a1daytst2pycntk
```
6. A successful ACI container execution will produce the following output

```
*** A1Day Python CNTK Container Group
a1day23544pycntk
****************
Storage Acct: a1daytst2pycntk
Storage Key: cGzdTPVNDqBV4ea742igFF+1hzWUJvVDOLiPVdxG4ON71wCM76dBDbgxtapubUUPJ0lXmHj1yIGc3AwTuhX1bQ==
{
  "additionalProperties": {},
  "containers": [
    {
      "additionalProperties": {},
      "command": null,
      "environmentVariables": [
        {
          "additionalProperties": {},
          "name": "MODEL_RUN",
          "value": "a1day23544pycntk"
        }
      ],
      "image": "a1daycntk01.azurecr.io/azureworkshop/a1day-python-cntk:v1",
      "instanceView": null,
      "name": "a1day23544pycntk",
      "ports": [],
      "resources": {
        "additionalProperties": {},
        "limits": null,
        "requests": {
          "additionalProperties": {},
          "cpu": 1.0,
          "memoryInGb": 1.5
        }
      },
      "volumeMounts": [
        {
          "additionalProperties": {},
          "mountPath": "/env",
          "name": "azurefile",
          "readOnly": null
        }
      ]
    }
  ],
  "id": "/subscriptions/aa843008-1bae-4ffc-aa4c-5d65505c4a7c/resourceGroups/a1day-cntk01/providers/Microsoft.ContainerInstance/containerGroups/a1day23544pycntk",
  "imageRegistryCredentials": [
    {
      "additionalProperties": {},
      "password": null,
      "server": "a1daycntk01.azurecr.io",
      "username": "a1daycntk01"
    }
  ],
  "instanceView": {
    "additionalProperties": {},
    "events": [],
    "state": "Pending"
  },
  "ipAddress": null,
  "location": "eastus",
  "name": "a1day23544pycntk",
  "osType": "Linux",
  "provisioningState": "Creating",
  "resourceGroup": "a1day-cntk01",
  "restartPolicy": "Never",
  "tags": null,
  "type": "Microsoft.ContainerInstance/containerGroups",
  "volumes": [
    {
      "additionalProperties": {},
      "azureFile": {
        "additionalProperties": {},
        "readOnly": null,
        "shareName": "pycntk",
        "storageAccountKey": null,
        "storageAccountName": "a1daytst2pycntk"
      },
      "emptyDir": null,
      "gitRepo": null,
      "name": "azurefile",
      "secret": null
    }
  ]
}
****************
Launched Container: a1day23544pycntk
****************
Container 'a1day23544pycntk' is in state 'Unknown'...
Container 'a1day23544pycntk' is in state 'Waiting'...
Container 'a1day23544pycntk' is in state 'Running'...
(count: 1) (last timestamp: 2018-05-09 19:58:20+00:00) pulling image "a1daycntk01.azurecr.io/azureworkshop/a1day-python-cntk:v1"
(count: 1) (last timestamp: 2018-05-09 20:01:43+00:00) Successfully pulled image "a1daycntk01.azurecr.io/azureworkshop/a1day-python-cntk:v1"
(count: 1) (last timestamp: 2018-05-09 20:01:43+00:00) Created container with id 146dae6803069018eca6c6ce08dc4e67c5b984ce21772954bbf4af1fca99a358
(count: 1) (last timestamp: 2018-05-09 20:01:43+00:00) Started container with id 146dae6803069018eca6c6ce08dc4e67c5b984ce21772954bbf4af1fca99a358

Start streaming logs:
Selected CPU as the process wide default device.

Begin binary classification (two-node technique)

Using CNTK version = 2.5.1

Creating a 18-20-2 tanh-softmax NN
Creating a cross entropy batch=10 SGD LR=0.005 Trainer

Starting training

batch    0: mean loss = 0.6932, accuracy = 40.00%
batch  500: mean loss = 0.7084, accuracy = 30.00%
batch 1000: mean loss = 0.5456, accuracy = 90.00%
batch 1500: mean loss = 0.4894, accuracy = 80.00%
batch 2000: mean loss = 0.4164, accuracy = 80.00%
batch 2500: mean loss = 0.7000, accuracy = 80.00%
batch 3000: mean loss = 0.2024, accuracy = 100.00%
batch 3500: mean loss = 0.1493, accuracy = 100.00%
batch 4000: mean loss = 0.2583, accuracy = 90.00%
batch 4500: mean loss = 0.3860, accuracy = 90.00%

Training complete

Evaluating accuracy using built-in test_minibatch()

Classification accuracy on the 297 data items = 84.18%

Saved Cleveland Heart Disease Model to: /env/Model/cleveland_bnn_a1day23544pycntk.model

End Cleveland Heart Disease classification
```
7. Go back to the Azure portal, and select the Container Instance that was created.  Under Settings, select Containers to view information about the container execution.  As this container is designed to run to completion (batch) it will be terminated.  Select the Logs tab, and you will see that activity logged within the container to Sysout is captured for reference and debugging.

8. Next, go back to the Storage Account we created and initialized earlier.  If you review the ```az container``` command used by the helper script, you will see that we mounted the related Fileshare to the ```/env``` Volume we defined within the Docker image.  Browse the Fileshare on the Storage Account, and you will see that a new output Model was created with a name that matches the container instance/training run in the Model directory

**We now have basic Container framework that can be repeatedly used for updating and training ML Models, using the on-demand Container execution available from Azure ACI.  New data can be easily injected into the Container/Training run by updating the Azure Fileshare input data, and output results and ML Model captured for each run for further analysis or real-world application**
