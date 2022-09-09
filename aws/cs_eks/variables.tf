variable "region" {
  type        = string
  description = "AWS region to use for creating resources"
  default     = "us-west-1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS authentication access key"
}
variable "aws_secret_key" {
  type        = string
  description = "AWS authentication secret key"
}

# VM Variables
variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "VM Instance size"
}

variable "linux_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    projectname = "Qualys-Container-Sensor-QCS"
    env         = "Qualys-POC-Demo"
    owner       = "Qualys"
    department  = "POC-Demo"
  }
}

variable "prefix" {
  type        = string
  default     = "qcs"
  description = "All resources would have this prefix for identification"
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

# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.1.64.0/18"
}

# Subnet Variables
variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.64.0/24"
}

