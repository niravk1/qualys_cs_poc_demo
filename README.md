# Qualys Container Security Demo
Qualys Container Security Demo on Azure Cloud. 

![tf-qcs-aks-acr-azdo](https://user-images.githubusercontent.com/12005983/180643185-6ab85d6a-def0-40a2-9a2c-4e6700c12343.svg)

NOTE : This demo is tested on macOS (Apple M1 Pro chip).

# Prerequisite
Below tools are required to setup and configure Qualys Container Security, Proof of concept/value (POC/POV) & Demonstration (demo).
| Azure Cloud Account      | Azure DevOps Account          | 
| ------------- |:-------------:|
| Azure Command-Line Interface (CLI) | terraform                          |
|           docker                   | git                                |
|           kubectl                  | 

# Acronyms
tfqcs : Terraform Qualys Container Sensor \
qcs : Qualys Container Sensor \
rg : resource group \
aks : Azure Kubernetes Service \
acr : Azure Container Registry \
azdo : Azure DevOps


# Important Information
- Terraform modules are not used for this POC/Demo setup for simplicity and easy understanding. 
- Make sure either you stop the resources or delete the environment "terraform destroy", to avoid cloud charges. 
- By default UbuntuServer 18.04-LTS is used for Registry mode Container Sensor VM

# Setup 

## Configure
### terraform.tfvars : Input variables let you customize aspects of Terraform modules without altering the module's own source code. This allows you to share modules across different Terraform configurations, making your module composable and reusable.

### Authentication to Cloud : Default method used for Azure authentication is Single Sign-On. If you need to use another method, you will need to updated few code/configuration in Terraform.  

## Start POC/Demo
git clone https://github.com/niravk1/qualys_cs_poc_demo.git \
cd qualys_cs_poc_demo/azure/cs_aks_acr_azdo 

- Update terraform.tfvars (Imp : Azure DevOps Org Url , Personal Access Token, Qualys Activation/Customer ID and POD URL)

./env_prep.sh \
terraform init \
terraform validate \
terraform plan \
terraform apply \
./demo_prep.sh 

## Destroy POC/Demo
terraform destroy 
- Manual clean-up of Qualys Cloud Platform entries
- Manual clean-up of ~/.kube/config file (if required)

# Future Enhancements: Work In Progress updates
1. Create Terraform modules for Azure POC/Demo
2. Install Qualys Cloud Agent
3. Qualys Container Sensor POC, Demo on AWS Cloud
4. Qualys Patch Management Demo 
5. Azure DevOps (AZDO) build pipeline updates 
6. IaC Scanning and QFlow automation
7. Test this POC-Demo on Linux and Windows workstation 

# License
THIS SCRIPT IS PROVIDED TO YOU "AS IS." TO THE EXTENT PERMITTED BY LAW, QUALYS HEREBY DISCLAIMS ALL WARRANTIES AND LIABILITY FOR THE PROVISION OR USE OF THIS SCRIPT. IN NO EVENT SHALL THESE SCRIPTS BE DEEMED TO BE CLOUD SERVICES AS PROVIDED BY QUALYS

