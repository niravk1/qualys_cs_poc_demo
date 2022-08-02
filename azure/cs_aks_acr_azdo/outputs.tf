output "random_integer" {
  value = random_integer.qcs.result
}

output "random_pet" {
  value = random_pet.qcs.id
}

output "resource_group_name" {
  value = azurerm_resource_group.qcs.name
}

output "azurerm_linux_virtual_machine" {
  value = azurerm_linux_virtual_machine.qcs.name
}

output "tls_private_key" { 
    value = tls_private_key.qcs.private_key_pem 
    sensitive = true
}

output "static_public_ip" {
  value = azurerm_public_ip.qcs.ip_address
}

### Kubernetes Service ###
output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.qcs.name
}

output "azurerm_container_registry" {
  value = azurerm_container_registry.qcs.name
}

### AZDO ###
output "Project_ID" {
  value = azuredevops_project.qcs.id
}

#output "Project_URL" {
#  value = azuredevops_project.project.url
#}

### Commands to Execute after terraform run
output "z_run_demo_prep" {
  description = "Display the output"
  value       = "RUN THE SCRIPT DEMO_PREP : ./demo_Prep.sh"
}

