#------------------------------
# subnet
#------------------------------
resource "aws_subnet" "public" {
  for_each   = var.subnets_public
  vpc_id     = var.vpc_id
  cidr_block = each.value
  tags       = { Name = "${var.tags_name}-${each.key}" }
}