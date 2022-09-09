## Configure
### terraform.tfvars : Input variables let you customize aspects of Terraform modules without altering the module's own source code. This allows you to share modules across different Terraform configurations, making your module composable and reusable.

### Authentication to Cloud : Default method used for AWS authentication is using Access and Secret Key. If you need to use another method, you will need to updated few code/configuration in Terraform.  

## Start POC/Demo
git clone https://github.com/niravk1/qualys_cs_poc_demo.git \
cd qualys_cs_poc_demo/aws/cs_eks 

- Update terraform.tfvars (Imp : AWS credentials, Qualys Activation/Customer ID and POD URL)

chmod +x *.sh ; ./env_prep.sh \
terraform init \
terraform apply \
./demo_prep.sh 

## Destroy POC/Demo
terraform destroy 
- Manual clean-up of Qualys Cloud Platform entries
- Manual clean-up of ~/.kube/config file (if required)
