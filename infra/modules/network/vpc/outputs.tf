#------------------------------
# vpc
#------------------------------
output "vpc_id" {
  description = "他リソースに連携用のVPC_ID"
  value       = aws_vpc.main.id
}