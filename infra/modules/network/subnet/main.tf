#------------------------------
# subnet
#------------------------------
resource "aws_subnet" "main" {
  for_each   = var.subnet_map
  vpc_id     = var.vpc_id
  cidr_block = each.value
  tags = { Name = var.tags_name }
}