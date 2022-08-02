#!/bin/bash

# Color Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${RED}m"
NC='\033[0m'

# Azure resources variables from terraform 
acr=`terraform output -raw azurerm_container_registry`
arg=`terraform output -raw resource_group_name`
akscluster=`terraform output -raw kubernetes_cluster_name`
pubip=`terraform output static_public_ip`

# Functions 

function sensorprep {

  sed -i -e "s/active00-0000-0000-0000-000000000000/$(grep "^activ" terraform.tfvars | cut -d "\"" -f2)/g" deployments/cssensor-containerd-ds.yml
  sed -i -e "s/custom00-0000-0000-0000-000000000000/$(grep "^custom" terraform.tfvars | cut -d "\"" -f2)/g" deployments/cssensor-containerd-ds.yml
  sed -i -e "s,pod_url,$(grep "^pod_url" terraform.tfvars | cut -d "\"" -f2),g" deployments/cssensor-containerd-ds.yml
  echo "CS Sensor Configured with Qualys IDs for your account." 
} # End sensorprep

function vmlogin {
  chmod 640 id_rsa ; rm -f id_rsa

  terraform output -raw tls_private_key > id_rsa
  chmod  400 id_rsa

  echo -e "${ORANGE}You will need to clean-up ~/.kube/config file manually, if needed."
  echo -e "id_rsa created in the present working directory to login to VM." 
  echo -e "You can login to CS Registry Sensor VM using below command."
  echo -e "ssh -i id_rsa azureuser@${pubip} ${NC}"
} # End vmlogin 

function aks_deploy {
  for i in $(kubectl config get-clusters | grep tfqcs-aks | grep -v NAME) ; do
	kubectl config delete-context $i
  done

  az aks get-credentials --resource-group ${arg} --name ${akscluster}
  az aks browse --resource-group ${arg} --name ${akscluster}
  kubectl config get-contexts
  kubectl get nodes -o wide

  echo "Deploying CS Sensor in Cluster ${akscluster}."
  kubectl create -f deployments/cssensor-containerd-ds.yml

  echo "Deploying example App in Cluster ${akscluster}."
  kubectl create -f deployments/voting-app-k8s-deploy.yml 
} # End aks_deploy

function sec-lock-keychain {
    security lock-keychain
} # End sec-lock-keychain

function sec-unlock-keychain {
    echo "Enter you Mac password to login to Container Regitry."
    security unlock-keychain
    az acr login --name ${acr}
} # End sec-unlock-keychain

function dockerpushacr {
    cimg=$1
    docker pull -q ${cimg}
    docker tag ${cimg} ${acr}.azurecr.io/${cimg}
    docker push ${acr}.azurecr.io/${cimg}
    echo "== Pushed ${cimg} to Azure Container Registry :${acr}."
} # End dockerpushacr




### Main ###

sensorprep

sec-unlock-keychain
dockerpushacr busybox:latest
dockerpushacr redis:latest
dockerpushacr redis:7.0-bullseye
sec-lock-keychain

aks_deploy
vmlogin 

