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

# AWS resources variables from terraform 
region=`terraform output -raw region`
cluster=`terraform output -raw cluster_name`

# Functions 

function sensorprep {

  sed -i -e "s/active00-0000-0000-0000-000000000000/$(grep "^activ" terraform.tfvars | cut -d "\"" -f2)/g" deployments/cssensor-ds.yml
  sed -i -e "s/custom00-0000-0000-0000-000000000000/$(grep "^custom" terraform.tfvars | cut -d "\"" -f2)/g" deployments/cssensor-ds.yml
  sed -i -e "s,pod_url,$(grep "^pod_url" terraform.tfvars | cut -d "\"" -f2),g" deployments/cssensor-ds.yml
  echo "CS Sensor Configured with Qualys IDs for your account." 
} # End sensorprep

function eks_deploy {
  for i in $(kubectl config get-clusters | grep tfqcs-eks | grep -v NAME) ; do
	kubectl config delete-context $i
  done

  aws eks --region ${region} update-kubeconfig --name ${cluster}
  kubectl config get-contexts
  kubectl get nodes -o wide

  echo "Deploying CS Sensor in Cluster ${akscluster}."
  kubectl create -f deployments/cssensor-ds.yml

  echo "Deploying example App in Cluster ${akscluster}."
  kubectl create -f deployments/voting-app-k8s-deploy.yml 
} # End eks_deploy


### Main ###

sensorprep
eks_deploy


