#------------------------------
# subnet
#------------------------------
resource "aws_subnet" "private" {
  for_each   = var.subnets_private
  vpc_id     = var.vpc_id
  cidr_block = each.value
  tags       = { Name = "${var.tags_name}-${each.key}" }
}