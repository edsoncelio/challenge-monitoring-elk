provider "aws" {
  region = var.provider_region
}

data "aws_ami" "packer_ami" {
  most_recent = true

  owners = ["self"]

  filter {
    name   = "name"
    values = ["packer-ubuntu-18-04-*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 3.18"

  name        = "HTTP security group"
  description = "Security group to open HTTP port"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = var.sg_ingress_cidr_block
}

module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 3.0"

  name        = "SSH security group"
  description = "Security group to open SSH port"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = var.sg_ingress_cidr_block
}

# EC2 Instance
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.17"

  name           = var.instance_name
  instance_count = var.instance_count
  #key_name = var.instance_key_name
  ami           = data.aws_ami.packer_ami.id
  instance_type = var.instance_type
  monitoring    = var.instance_monitoring

  vpc_security_group_ids = [module.http_sg.this_security_group_id, module.ssh_sg.this_security_group_id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]

  tags = var.instance_tags

  depends_on = [
    aws_elasticsearch_domain.elk,
  ]
}

# # #Managed ELK
resource "aws_elasticsearch_domain" "elk" {
  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version
  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain_name}/*"
        }
    ]
}
CONFIG
  cluster_config {
    instance_type = var.es_instance_type
  }

  node_to_node_encryption {
    enabled = true
  }
  encrypt_at_rest {
    enabled = true
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }
  ebs_options {
    ebs_enabled = true
    volume_size = var.es_ebs_size
  }
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.es_master_user_name
      master_user_password = var.es_master_user_password
    }

  }
  tags = var.instance_tags

  provisioner "local-exec" {
    command = "sed 's/url/${self.endpoint}:443/g' ../packer/playbook/files/30-elasticsearch-output.conf.j2 > ../packer/playbook/files/30-elasticsearch-output.conf; cd ../packer; packer build ."
  }
}
