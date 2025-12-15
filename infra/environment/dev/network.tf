#------------------------------
# vpc
#------------------------------
module "vpc_dev" {
  source      = "../../modules/vpc.tf"
  vpc_cidr    = var.vpc_cidr
  vpc_tenancy = var.vpc_tenancy
  tags_name   = "${var.project}-vpc-${var.env}"
}

#------------------------------
# subnet
#------------------------------
module "subnet_dev" {
  source     =  "../../modules/subnet.tf"
  vpc_id     = var.vpc_id
  for_each   = var.subnet_map
  cidr_block = each.value
  tags_name   = "${var.project}-subnet-${var.env}"
}