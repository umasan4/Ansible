#------------------------------
# rt_public
#------------------------------
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = { Name = var.tags_name }
}

#------------------------------
# rt_public / route
#------------------------------
resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.igw_id
}

#------------------------------
# rt_public / association
#------------------------------
resource "aws_route_table_association" "public" {
  for_each = var.subnet_ids
  subnet_id = each.value
  route_table_id = aws_route_table.public.id
}