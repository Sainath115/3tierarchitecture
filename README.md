# 3tierarchitecture
3-tier architecture


# jumpstart-vmss

[[_TOC_]]

# Kit Description
For information on how to use Stratum-based kits, such as adding and removing layers, deploying multiple layers of the same resource type, composing custom layers, and more; see [Stratum Kits Wiki](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_wiki/wikis/DevOps%20Automation/1467/Understand-layers-workflow).

## This kit contains:
- Resource Group
- Virtual networks, subnets, network security groups
- Log Analytics Workspace
- Storage account
- Key Vault
- Key Vault Diagnostics
- Linux Virtual Machine Scale Set
- Azure SQL database
- Load balancers
- Applicaiton Gateway
- NSG flow logs
- Private endpoints
- Private DNS
- Private DNS A Records
- Private Link Service
- VM Alerts
- VM Dashboards
- VM Workbooks

# Pre-requisites
- Service connection to the ACC-Azure-00 Stratum artifact feed
    - Project Settings -> Service Connections -> New Service Connection -> Azure Repos/Team Foundation Server
    - Connection URL: https://dev.azure.com/ACC-Azure-00
    - Personal Access Token: Token with "Packaging Read" access
    - Service Connection Name: ACC-Azure-00 Stratum Feed
- Separate service connections to required subscriptions
- [DevOps Onboarding Services (contains storage account for state)](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/att-onboarding-devops-services?path=%2FREADME.md&_a=preview)
- [Image Builder pipeline (if using custom images)](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/jumpstart-image-builder-sig?path=%2FREADME.md&_a=preview)
- A container in the state storage account
- ADO agent MSI has storage account key operator role on the storage where state is saved

# Step-by-Step: Minimum variables to change to deploy
Ideally all variable values in /layers/env should be reviewed to enusre they meet your application requirements.  For example, a resource group is named in each layer and while it may not be required to deploy the kit, it is recommended to change the value.  Due to the fact that some values are used in different files, it is recommended to find and replace in all files in the folder to ensure you update all references.  To deploy this kit on first attempt, the following minimum modifications are required:

## Preparing Kit
1. Download the kit version from the [artifact feed](https://dev.azure.com/ACC-Azure-00/Stratum).  The download command will be on the overview page of the artifact you choose.  You may need to set your proxy to use the CLI, including some possible updates to python via cmd.exe
    * "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\python" -m pip install --upgrade pip
    * "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Scripts\pip" install python-certifi-win32
    * set http_proxy=http://sub.proxy.att.com:8080
    * set https_proxy=http://sub.proxy.att.com:8080
    * set AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1
1. Create a repo for your application in your ADO organization
1. Add the Layers and Pipelines folders to your repo
1. Modify the files below

**NOTE: Only the kit must be downloaded.  Layers do not need to be downloaded as they will be retrieved as your pipeline runs**

## Variables.yaml
1. motsId
1. agent_pool - Name of the ADO agent pool (see: pre-reqs)
1. artifactFeedCredentials - PAT based service connection name to the artifact feed (see: pre-reqs)
1. pipelineId - The pipeline ID of image builder (if using IB)

## Variables.dev.yaml
1. serviceConnectionApp - Service connection name to dev subscription
1. backendResourceGroupName - Resource Group where storage account containing Terraform state resides
1. backendStorageAccountName - Storage account where Terraform state will reside
1. backendContainerName - Container name for Terraform state## Pipeline.dev.yaml
1. Remove resources block where noted if not planning to use Image Builder on first deployment
1. useMsi - true or false depending on whether you are using a managed identity for your ADO agent pool (true is preferred)

## Pipeline.dev.yaml
1. Remove resources block where noted if not planning to use Image Builder on first deployment

**It is recommended to "Find in files" for Layers/<env> and replace to update all references for the files below.  These instructions assume find and replace was used and does not identify all reference points for the variable changes**

## var-resourcegroup.auto.tfvars
1. resource_groups.resource_group_1.name - Find and replace in all files

## var-storage.auto.tfvars
1. storage_accounts.sa1.name - Find and replace in all files

## var-keyvault.auto.tfvars
1. name - Find and replace in all files

## var-privateendpoints.auto.tfvars
1. private_endpoints.pe1.resource_name - Must match what was changed in var-keyvault.auto.tfvars

## var-adoprivateendpoints.auto.tfavrs
1. ado_private_endpoints.ape1.name - Name of the PE to create a PE to ADO agent for
1. ado_private_endpoints.ape.resource_name - Resource name of the resource you wish to create a PE to the ADO agent for
1. ado_resource_group_name - Needed to create a PE for the ADO agent to access the deployed KV
1. ado_vnet_name - Needed to create a PE for the ADO agent to access the deployed KV
1. ado_subnet_name - Needed to create a PE for the ADO agent to access the deployed KV
1. ado_subscription_id - Needed to create a PE for the ADO agent to access the deployed KV

## var-loganalytics.auto.tfvars
1. name

## var-azsql.auto.tfvars
1. server_name

## var-applicationgateway.auto.tfvars
1. key_vault_resource_group - App gateway requires a certificate on an existing keyvault
1. key_vault_name - App gateway requires a certificate on an existing keyvault

# Adding and Removing Layers
## Adding
1. Identify the layer and version you wish to add
1. Add an object to the layer parameters in Pipeline.<env>.yaml
1. Use the examples auto.tfvars file included with the layer as a starting point
1. Name the auto.tfvars file the same as the layer name ie: var-<layername>.auto.tfvars

## Adding multiple layers of the same type
Multiple layers of the same type can be added by setting the layer name attributes in Pipeline.<env>.yaml.  This example deploys two resource group layers with one network layer dependent.  Note the dependencies for the networking (myrg1: resourcegrup).  **When a layer has a custom name, there must be a matching variable file (var-myrg1.auto.tfvars instead of var-resourcegroup.auto.tfvars)**

    name: myrg1
    type: resourcegroup
    version: "0.0.1"
    skip: false
    dependencies:
      start: start

    name: myrg2
    type: resourcegroup
    version: "0.0.1"
    skip: false
    dependencies:
      start: start

    name: networking
    type: networking
    version: "0.0.1"
    skip: false
    dependencies:
      myrg1: resourcegroup

## Removing layers
1. Remove the reference from Pipeline.<env>.yaml
1. Delete the matching auto.tfvars file
**Note: Removing a layer does not destroy the resource**

# Skipping Layers
There are two ways to skip layers.  These exist to focus troubleshooting efforts.

## Setting skip: true
Each layer has a "skip: false" by default.  When setting this to true, the stage will still run however Terraform will not execute.  If skipping the first layer (usually resourcegroup), "start: start" must be placed in the first layer that is not skipped.  Since resourcegroup is a fast layer and automatic skip detection will not attempt to apply, it is usually recommended to leave the first layer as skip: false.

## Automatic Skip Detection
When the Terraform plan stage does not detect any changes, the apply stage will not execute any Terraform commands.  The stage will still run, however Terraform plan is skipped.  This is not optional
