#------------------------------
# rt_private
#------------------------------
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags   = { Name = var.tags_name }
}

#------------------------------
# rt_private / route
#------------------------------
resource "aws_route" "private_eni_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.eni_id
}

#------------------------------
# rt_private / association
#------------------------------
resource "aws_route_table_association" "private" {
  for_each       = var.subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}