## Azure Container Registry (ACR)

Now that we have container images for our application component, we need to store them in a secure, central location. In this lab we will use Azure Container Registry for this.

### Create Azure Container Registry instance

1. In the browser, sign in to the Azure portal at https://portal.azure.com.
2. Click "Create a resource" and select "Azure Container Registry"
3. Provide a name for your registry (this must be unique)
4. Use the existing Resource Group
5. Enable the Admin user
6. Use the 'Standard' SKU (default)

    > The Standard registry offers the same capabilities as Basic, but with increased storage limits and image throughput. Standard registries should satisfy the needs of most production scenarios.

### Login to your ACR with Docker

1. Browse to your Container Registry in the Azure Portal
2. Click on "Access keys"
3. Make note of the "Login server", "Username", and "password"
4. In a Powershell session on your developer VM, execute the command below

    ```
    # Be sure to replace the <ACR_*> values with your own

    docker login --username <ACR_USER> --password <ACR_PWD> <ACR_SERVER>
    ```

### Tag image with ACR server and repository 

```
# Be sure to replace the <ACR_SERVER> value

docker tag a1day-python-cntk:latest <ACR_SERVER>/azureworkshop/a1day-python-cntk:v1
```

### Push image to registry

```
docker push <ACR_SERVER>/azureworkshop/a1day-python-cntk:v1

```

Output from a successful `docker push` command is similar to:

```
The push refers to a repository [mycontainerregistry.azurecr.io/azureworkshop/a1day-python-cntk]
035c23fa7393: Pushed
9c2d2977a0f4: Pushed
d7b18f71e002: Pushed
ec41608c0258: Pushed
ea882d709aca: Pushed
74bae5e77d80: Pushed
9cc75948c0bd: Pushed
fc8be3acfc2d: Pushed
f2749fe0b821: Pushed
ddad740d98a1: Pushed
eb228bcf2537: Pushed
dbc5f877c367: Pushed
cfce7a8ae632: Pushed
v1: digest: sha256:f84eba148dfe244f8f8ad0d4ea57ebf82b6ff41f27a903cbb7e3fbe377bb290a size: 3028
```

### Validate images in Azure

1. Return to the Azure Portal in your browser and validate that the images appear in your Container Registry under the "Repositories" area.
2. Under tags, you will see "v1" listed.