#sg envs
sg_ingress_cidr_block = ["0.0.0.0/0"]
#instance envs
instance_name  = "ec2-instance-elk"
instance_count = 1
instance_type  = "t2.small"
instance_key_name = "key-name"
#es envs
es_domain_name          = "elk-aws"
es_version              = "7.9"
es_instance_type        = "r4.large.elasticsearch"
es_ebs_size             = "10"
es_master_user_name     = "myAdminUser"
es_master_user_password = "myAwesomePassword2021@"