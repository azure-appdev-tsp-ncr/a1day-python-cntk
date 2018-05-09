## Create python CNTK using Local Docker/VS Code IDE

### Create developer VM using base Windows Server 2016 Datacenter image from the Azure Marketplace.
1. Use a D4s_v3 Type/Size which supports nested virtualization needed for Docker
2. Make sure to enable the RDP(3389) inbound port
3. Use the remaining defaults and create the VM

### Connect to VM and add required development tooling
1. From the Windows Command Prompt, install the Chocolatey Package Manager by running the following command:
```
 @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" 
 ```
 2. From Powershell (all examples will use Powershell going forward), execute the following command to install the additional developer tooling and utilities
 ```
 cinst git visualstudiocode azure-cli docker docker-for-windows kubernetes-cli -y
 ```
 3. When the package installation is complete, close Powershell session and use Desktop Icon to start Docker initialization.  You will be prompted to initially logout, just restart the VM.  Two restarts will be required to fully initialize the Hyper-V subsystem for Docker to operate.  Follow the prompts from Docker.  
 4. After the 2nd VM restart and successful Docker startup, open a Powershell session and execute the following command to verify Docker install
 ```
 docker run -it centos bash
 ```
 5. You should see something like the following (exit the container as shown)
 ```
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
469cfcc7a4b3: Pull complete
Digest: sha256:989b936d56b1ace20ddf855a301741e52abca38286382cba7f44443210e96d16
Status: Downloaded newer image for centos:latest
[root@e2584d2044c8 /]# exit
exit
```
 ### Clone this source repo and open in VS Code
 1. Execute git clone into your home directory, change directories to project base and lauch VisualCode
 ```
 git clone https://github.com/azure-appdev-tsp-ncr/a1day-python-cntk.git
 cd a1day-python-cntk
 code .\
 ```
 2. The VisualCode IDE should now be open to your project folder, and you should see all the project files and directories on the left Explorer navigation pane.
 3. Next, select the Dockerfile in the project.  Install the Docker extension when prompted, which enables Docker commands to be run from the IDE.  Some additional recommendations will be displayed, you can ignore or also install the Azure CLI Tools for later experimentation.
 4. Select the Explorer icon on left navigation pane, and select and review the Dockerfile in the project.  You will notice that a non-Root user (1001) is being configured to run processes within the Docker container, this is a best practice to prevent any accidental or purposeful exscalation of container privileges.
 5. Right-click the Dockerfile, and select the "Build Image" from the items at the bottom of the displayed list (may have to restart VS Code if this doesn't initially display).  Press enter to accept the default image name (displayed in command pallette at top of IDE).
 6. Once Docker image successfully builds, use instructions in comments to perform local unit test of the image from Terminal window in VS Code.  You should see something similar to the following
 ```
docker run -it -e 'APP_ROOT=/opt/a1day-python-cntk' a1day-python-cntk:latest

Begin binary classification (two-node technique)

Using CNTK version = 2.5.1

Creating a 18-20-2 tanh-softmax NN
Selected CPU as the process wide default device.
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

Saved Cleveland Heart Disease Model to: /opt/a1day-python-cntk/Model/cleveland_bnn_local01.model
```

**We have now successfully created and unit tested our Docker Image which can now be pushed to either the Azure Container Registery or Docker Hub for batch execution on Azure**
