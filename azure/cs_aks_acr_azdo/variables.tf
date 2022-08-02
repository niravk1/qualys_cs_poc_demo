### Azure, Naming & Tags Configuration ###

variable "location" {
  type = string
  default = "West US"
  description = "Cloud location"
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    projectname = "Qualys-Container-Sensor-QCS"
    env = "Qualys-POC-Demo"
    owner = "Qualys"
    department = "POC-Demo"
  }
}

# Project name prefix 
variable "prefix" {
  type = string
  default = "qcs"
  description = "All resources would have this prefix for identification"
}

### Virtual Machine Configuration ###
variable "vmsize" {
  type = string
  default = "Standard_B2s"
  description = "Virtual Machine Size"
}

variable "vmadminuser" {
  type = string
  default = "azureuser"
  description = "VM Admin Username"
}

variable "vmpassword" {
  type = string
  description = "VM Password"
}

### Azure Kubernetes Service (AKS) Configuration ###
variable "aks_worker_node_count" {
  type = number
  default = "1"
  description = "Number of worker nodes in AKS cluster"
}

variable "aks_worker_vmsize" {
  type = string
  default = "Standard_B4ms"
  description = "VM Size for AKS worker node"
}

variable "aks_worker_os_disksize" {
  type = number
  default = "30"
  description = "VM node disk size for AKS worker node"
}

### Azure DevOps (AZDO) Configuration ###
variable "pat" {
  type        = string
  description = "Azure DevOps Personal Access Token"
}

variable "org_service_url" {
  type	      = string
  description = "Azure DevOps Organization Service URL" 
} 

### Qualys Container Sensor 
variable "activationid" {
  type	      = string
  description = "Qualys specific activation id"
}

variable "customerid" {
  type	      = string
  description = "Qualys specific customer id" 
}

variable "pod_url" {
  type	      = string
  description = "Qualys specific pod url" 
}


### Azure Authentication Configuration ###
#Azure authentication variables
#variable "azure_subscription_id" {
#  type = string
#  description = "Azure Subscription ID"
#}
#variable "azure_client_id" {
#  type = string
#  description = "Azure Client ID"
#}
#variable "azure_client_secret" {
#  type = string
#  description = "Azure Client Secret"
#}
#variable "azure_tenant_id" {
#  type = string
#  description = "Azure Tenant ID"
#}
