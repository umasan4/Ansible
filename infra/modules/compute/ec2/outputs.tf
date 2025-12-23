# instance id
output "instance_id" {
  description = "created ec2 instance id"
  value = aws_instance.main.id
}

# eni id
# output "primary_network_interface_id" {
#   description = "for nat instance"
#   value       = aws_instance.main.primary_network_interface_id
# }