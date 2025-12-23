# instance id
output "instance_ids" {
  description = "created ec2 instance id map"
  value       = { for key, value in aws_instance.main : key => value.id }
}

# eni_id
output "network_interface_ids" {
  description = "created ec2 nat_instance eni_id map"
  value       = { for key, value in aws_instance.main : key => value.primary_network_interface_id }
}