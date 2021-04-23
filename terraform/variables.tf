#Instance variables
variable "instance_name" {
  description = "Instance name"
  type        = string
}

variable "instance_count" {
  description = "Instance count"
  type        = number
}
variable "instance_monitoring" {
  description = "Instance monitoring"
  type        = bool
  default     = true
}

variable "instance_tags" {
  description = "Instance tags"
  type        = map(string)
  default = {
    "Terraform" = "true"
  }
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "instance_key_name" {
  description = "Name of key pair"
  type = string
  default = ""
}

#Provider variables
variable "provider_region" {
  description = "Provider region"
  type        = string
  default     = "us-east-1"

}

#Security group variables
variable "sg_ingress_cidr_block" {
  description = "Security Group ingress cidr block"
  type        = list(string)
}

#Elastic Search variables
variable "es_domain_name" {
  description = "ElasticSearch domain name"
  type        = string
}

variable "es_version" {
  description = "ElasticSearch version"
  type        = string
}

variable "es_instance_type" {
  description = "ElasticSearch instance type"
  type        = string
}

variable "es_ebs_size" {
  description = "EBS storage size"
  type        = string
}

variable "es_master_user_name" {
  description = "ElasticSearch mmain user"
  type        = string
  sensitive   = true
}

variable "es_master_user_password" {
  description = "ElasticSearch main password"
  type        = string
  sensitive   = true
}


