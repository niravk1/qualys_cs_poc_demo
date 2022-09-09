#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${RED}m"
NC='\033[0m'

function checktools {
  if $(which -s git docker aws aws-iam-authenticator terraform kubectl ); then
    echo "Tools installed on Mac : git docker aws aws-iam-authenticator terraform kubectl , great."
  else
    echo "${RED}Either one or more tools are missing : git docker aws aws-iam-authenticator terraform kubectl${NC}"
  fi
} # End checktools

function activationid {
  while true
  do
  read -r -p "Did you update ActivationID, CustomerID and Pod URL in terraform.tfvars? [Y/n] " input
 
      case $input in
            [yY][eE][sS]|[yY])
                  echo "Great"
                  echo -e "==============================================================="
                  echo -e "${ORANGE}Execute below commands."
		  echo -e "1. terraform init" 
		  echo -e "2. terraform apply" 
		  echo -e "3. Execute after terraform creates environment : ./demo_prep.sh${NC}" 
                  echo -e "==============================================================="
                  break
                  ;;
            [nN][oO]|[nN])
                  echo "Please update and execute this script again."
                  break
                  ;;
            *)
                  echo "Invalid input..."
                  ;;
      esac      
done
} # End activationid

checktools
activationid
