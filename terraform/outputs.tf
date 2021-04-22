output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "kibana_endpoint" {
  value = aws_elasticsearch_domain.elk.kibana_endpoint
}
