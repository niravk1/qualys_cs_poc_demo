# Provider Configuration Variables
region     = "us-west-1" # Default location = "us-west-1"
aws_access_key = "AK000000000000000000"
aws_secret_key = "0000000000000000000000000000000000000000"

# VM Variables
instance_type = "t3.medium"
tags = {
  projectname = "Qualys-Container-Sensor-QCS" # Defaults projectname = "Qualys-Container-Sensor-QCS"
  env         = "Qualys-POC-Demo"                # Defaults env = "Qualys-POC-Demo"
  owner       = "Qualys"                 # Defaults owner = "Qualys"
  department  = "POC-Demo"                    # Defaults department = "POC-Demo"
}
prefix = "tfqcs" # Default qcs

### Qualys Container Sensor 
activationid="00000000-0000-0000-0000-000000000000"
customerid="00000000-0000-0000-0000-000000000000"
pod_url="https://cmsqagpublic.POD.apps.qualys.com/ContainerSensor"