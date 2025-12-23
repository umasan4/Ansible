#------------------------------
# vpc
#------------------------------
module "vpc_dev" {
  source      = "../../modules/network/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_tenancy = var.vpc_tenancy
  tags_name   = "${var.project}-vpc-${var.env}"
}

#------------------------------
# igw
#------------------------------
module "igw" {
  source = "../../modules/network/igw"
  vpc_id = module.vpc_dev.vpc_id
  tags   = "${var.project}-igw"
}

#------------------------------
# sg
#------------------------------
module "subnet_dev" {
  source     = "../../modules/network/subnet"
  vpc_id     = module.vpc_dev.vpc_id
  subnet_map = var.subnet_map
  tags_name  = var.project
}

#------------------------------
# rt_public
#------------------------------
module "public" {
  source     = "../../modules/network/rt_public"
  vpc_id     = module.vpc_dev.vpc_id
  igw_id     = module.igw.igw_id
  subnet_ids = { "nat-subnet-dev" = module.subnet_dev.subnet_ids["nat-subnet-dev"] }
  tags_name  = "${var.project}-rt-public-${var.env}"
}

#------------------------------
# rt_private
#------------------------------
module "private" {
  source     = "../../modules/network/rt_private"
  vpc_id     = module.vpc_dev.vpc_id
  eni_id     = module.nat.network_interface_ids["nat"]
  subnet_ids = { "target" = module.subnet_dev.subnet_ids["target-subnet-dev"] }
  tags_name  = "${var.project}-rt-private-${var.env}"
}