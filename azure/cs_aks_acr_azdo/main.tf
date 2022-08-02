resource "random_pet" "qcs" {}

# Create Random Integer
resource "random_integer" "qcs" {
  min = 1
  max = 99
}
 
# Create Resource Group
resource "azurerm_resource_group" "qcs" {
  name     = "${var.prefix}-rg${random_integer.qcs.result}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# Virtual Machine for Registry Sensor Deployment #
# Create virtual network
resource "azurerm_virtual_network" "qcs" {
  name                = "${var.prefix}-vnet${random_integer.qcs.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.qcs.location
  resource_group_name = azurerm_resource_group.qcs.name
}
# Create subnet
resource "azurerm_subnet" "qcs" {
  name                 = "${var.prefix}-subnet${random_integer.qcs.result}"
  resource_group_name  = azurerm_resource_group.qcs.name
  virtual_network_name = azurerm_virtual_network.qcs.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create network interface
resource "azurerm_network_interface" "qcs" {
  name                = "${var.prefix}-nic${random_integer.qcs.result}"
  location            = azurerm_resource_group.qcs.location
  resource_group_name = azurerm_resource_group.qcs.name

  ip_configuration {
    name                          = "${var.prefix}nicconfig"
    subnet_id                     = azurerm_subnet.qcs.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.qcs.id
  }
}
# Create public IPs
resource "azurerm_public_ip" "qcs" {
  name                = "${var.prefix}-publicip${random_integer.qcs.result}"
  location            = azurerm_resource_group.qcs.location
  resource_group_name = azurerm_resource_group.qcs.name
  allocation_method   = "Static"
}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "qcs" {
  name                = "${var.prefix}-nsg${random_integer.qcs.result}"
  location            = azurerm_resource_group.qcs.location
  resource_group_name = azurerm_resource_group.qcs.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "qcsassociate" {
  network_interface_id      = azurerm_network_interface.qcs.id
  network_security_group_id = azurerm_network_security_group.qcs.id
}
# Create keys
resource "tls_private_key" "qcs" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create VM 
resource "azurerm_linux_virtual_machine" "qcs" {
  name                  = "${var.prefix}-vm-reg-sen${random_integer.qcs.result}"
  location              = azurerm_resource_group.qcs.location
  resource_group_name   = azurerm_resource_group.qcs.name
  network_interface_ids = [azurerm_network_interface.qcs.id]
  size                  = "${var.vmsize}"

  os_disk {
    name              = "${var.prefix}-vm-reg-sen-osdisk${random_integer.qcs.result}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
    computer_name  = "${var.prefix}-vm-reg-sen${random_integer.qcs.result}"
    admin_username = "${var.vmadminuser}"
    disable_password_authentication = true

    admin_ssh_key {
      username   = "${var.vmadminuser}"
      public_key = tls_private_key.qcs.public_key_openssh
    }
  tags = "${var.tags}"
}

###
# Kubernetes Service
# Azure Kubernetes Service (AKS)

resource "azurerm_kubernetes_cluster" "qcs" {
  name                = "${var.prefix}-aks${random_integer.qcs.result}"
  location            = azurerm_resource_group.qcs.location
  resource_group_name = azurerm_resource_group.qcs.name
  dns_prefix          = "${var.prefix}-${random_pet.qcs.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = "${var.aks_worker_node_count}"
    vm_size         = "${var.aks_worker_vmsize}"
    os_disk_size_gb = "${var.aks_worker_os_disksize}"
  }

# To use when service principal needs to be used. 
#  service_principal {
#    client_id       = var.appId
#    client_secret   = var.password
#    subscription_id = "00000000-0000-0000-0000-000000000000"
#    tenant_id       = "00000000-0000-0000-0000-000000000000"
#  }

# Azure Provider: Authenticating using the Azure CLI
  identity {
    type = "SystemAssigned"
  }
  tags     = "${var.tags}"
}

# Azure Container Registry (ACR)

resource "azurerm_container_registry" "qcs" {
  name                = "${var.prefix}acr${random_integer.qcs.result}"
  resource_group_name = azurerm_resource_group.qcs.name
  location            = azurerm_resource_group.qcs.location
  sku                 = "Standard"
  admin_enabled       = false
  tags     = "${var.tags}"
}

resource "azurerm_role_assignment" "qcs" {
  principal_id                     = azurerm_kubernetes_cluster.qcs.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.qcs.id
  skip_service_principal_aad_check = true
}

### Pipeline
# Azure DevOps (AZDO) 

resource "azuredevops_project" "qcs" {
  name     	     = "${var.prefix}-azdo-project${random_integer.qcs.result}"
  description        = "Qualys Container Security Pipeline Security Demo"
  visibility         = "private" 	# Options private, public
  version_control    = "Git" 		# Options Git, Tfvc
  work_item_template = "Agile" 		# Options Agile, Basic, CMMI, Scrum

# Enable or disable the DevOps fetures below (enabled / disabled)
  features = {
      "boards" = "disabled"
      "repositories" = "enabled"
      "pipelines" = "enabled"
      "testplans" = "disabled"
      "artifacts" = "disabled"
  }
}

# Git Repository

resource "azuredevops_git_repository" "qcs" {
  project_id = azuredevops_project.qcs.id
  name       = "${var.prefix}-azdo-repo${random_integer.qcs.result}"
  initialization {
    init_type = "Clean"
#    init_type = "Import"
#    source_type = "Git"
#    source_url = "xxxxxxxxxxxxxxxxxxxx
  }
}

# To source from existing git repo.

#resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
#  project_id            = azuredevops_project.terraform_azdo_project.id
#  service_endpoint_name = "Sample GithHub Personal Access Token"
#
#  auth_personal {
#    # Also can be set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
#    personal_access_token = "xxxxxxxxxxxxxxxxxxxx"
#  }
#}

# Note that this example should import the GitHub Repo for this code into Azure DevOps.
#resource "azuredevops_git_repository" "imported_repo" {
#  project_id = azuredevops_project.terraform_azdo_project.id
#  name       = "Imported Repo"
#  initialization {
#    init_type = "Import"
#    source_type = "Git"
#    source_url = "xxxxxxxxxxxxxxxxxxxx
#  }
#}

# Build Defination (Pipeline) ########

# Define Variables in Azure DevOps to be used in Build Defination (Pipeline)
resource "azuredevops_variable_group" "qcs" {
  project_id   = azuredevops_project.qcs.id
  name         = "${var.prefix}-azdo-build-variables-${random_integer.qcs.result}"
  description  = "Managed by Terraform"
  allow_access = true
 
  variable {
    name  = "FOO"
    value = "BAR"
  }
  variable {
    name      = "FOO_SECRET"
    value     = "drop"
    is_secret = true
  }
}

# Define the Azure DevOps Build (Pipeline)
resource "azuredevops_build_definition" "build_definition" {
  project_id = azuredevops_project.qcs.id
  name       = "${var.prefix}-azdo-pipe${random_integer.qcs.result}"
  path       = "\\"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.qcs.id
    branch_name = azuredevops_git_repository.qcs.default_branch
    yml_path    = "azure-pipelines.yml"
    #    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }
  variable_groups = [azuredevops_variable_group.qcs.id]
}

resource "azuredevops_agent_pool" "qcs" {
  name           = "${var.prefix}-pool${random_integer.qcs.result}"
  auto_provision = false
}

# Local Execution of Scripts 

resource "null_resource" "local_provisioners" {
  
  depends_on = [
    azurerm_linux_virtual_machine.qcs , 
    azurerm_resource_group.qcs, 
    azurerm_kubernetes_cluster.qcs, 
    azurerm_container_registry.qcs,
    azuredevops_project.qcs
    ]

  provisioner "local-exec" {
      command = "/bin/bash scripts/local_script.sh"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "echo '----- Destroy-time provisioner -----' " 
  }
}

# Remote Execution of Scripts & Commands

resource "null_resource" "remote-exec" {
  depends_on = [
    azurerm_linux_virtual_machine.qcs , 
    azurerm_resource_group.qcs, 
    azurerm_kubernetes_cluster.qcs, 
    azurerm_container_registry.qcs,
    azuredevops_project.qcs
    ]
    provisioner "file" {
    source      = "scripts/remote_script.sh"
    destination = "/tmp/remote_script.sh"
    
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.qcs.ip_address
      user        = "${var.vmadminuser}"
      private_key = tls_private_key.qcs.private_key_pem
    }
  }
  
    provisioner "remote-exec" {
    
    inline = [
      "echo \"export ACTIVATIONID=${var.activationid}\" >> ~/.bashrc" ,
      "echo \"export CUSTOMERID=${var.customerid}\" >> ~/.bashrc" ,
      "echo \"export POD_URL=${var.pod_url}\" >> ~/.bashrc" ,
      "export ACTIVATIONID=${var.activationid}" , 
      "export CUSTOMERID=${var.customerid}" , 
      "export POD_URL=${var.pod_url}" , 
      "echo \"ACTIVATIONID=${var.activationid}\" > /tmp/.qualysenv.list" ,
      "echo \"CUSTOMERID=${var.customerid}\" >> /tmp/.qualysenv.list" ,
      "echo \"POD_URL=${var.pod_url}\" >> /tmp/.qualysenv.list" ,

      "sudo chmod +x /tmp/remote_script.sh" ,
      "sudo /tmp/remote_script.sh" , 
      "rm -f /tmp/.qualysenv.list"

      ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.qcs.ip_address
      user        = "${var.vmadminuser}"
      private_key = tls_private_key.qcs.private_key_pem
    }
  }
}
