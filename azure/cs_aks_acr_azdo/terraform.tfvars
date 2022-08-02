### Azure Authentication Configuration ###
#azure_client_id = "your-azure-client-id"
#azure_client_secret = "your-azure-client-secret"
#azure_subscription_id = "your-azure-subscription-id"
#azure_tenant_id = "your-azure-tenant-id"


### Azure, Naming & Tags Configuration ###
location = "Australia Southeast"        # Default location = "West US"
tags = {
projectname = "Qualys-Container-Sensor-QCS"  # Defaults projectname = "Qualys-Container-Sensor-QCS"
env = "Qualys-POC-Demo"                         # Defaults env = "Qualys-POC-Demo"
owner = "Qualys"  		          # Defaults owner = "Qualys"
department = "POC-Demo"                      # Defaults department = "POC-Demo"
}
prefix = "tfqcs"                        # Defaults prefix = "qcs" 

### Virtual Machine Configuration ###
vmsize = "Standard_B2s"                 # Default vmsize = "Standard_B2s"
vmadminuser = "azureuser"               # vmadminuser = "azureuser" 
vmpassword = ""

### Azure Kubernetes Service (AKS) Configuration ###
aks_worker_node_count = "1"             # Default aks_worker_node_count = "1"  
aks_worker_vmsize = "Standard_B4ms"     # Default aks_worker_vmsize = "Standard_B4ms"
aks_worker_os_disksize = "30"             # Default aks_worker_os_disksize = "30" 

### Azure DevOps (AZDO) Configuration ###
pat = "abcvdefg01234567abcdefg01234567abcvdefg01234567abcde"
org_service_url = "https://dev.azure.com/orgname"

### Qualys Container Sensor 
activationid="00000000-0000-0000-0000-000000000000"
customerid="00000000-0000-0000-0000-000000000000"
pod_url="https://cmsqagpublic.POD.apps.qualys.com/ContainerSensor"
