variable "ami_name" {
  type    = string
  default = "packer-ubuntu-18-04"
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
    type = string
    default = "ami-013f17f36f8b1fefb" 
}

variable "ssh_username" {
    type = string
    default = "ubuntu"
}

locals { 
    timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

