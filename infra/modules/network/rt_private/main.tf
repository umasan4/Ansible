#------------------------------
# route table association private
#------------------------------
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route = {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.eni_id
  }

  tags = { Name = var.tags_name }
}

resource "aws_route_table_association" "private" {
  for_each = var.subnet_ids
  subnet_id = each.value
  route_table_id = aws_route_table.private.id
}