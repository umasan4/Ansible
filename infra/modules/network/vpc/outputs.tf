#------------------------------
# vpc
#------------------------------
output "vpc_id" {
  description = "the id of the created VPC"
  value       = aws_vpc.main.id
}