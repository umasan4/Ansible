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
# subnet
#------------------------------
module "subnet_dev" {
  source     = "../../modules/network/subnet"
  vpc_id     = module.vpc_dev.vpc_id
  subnet_map = var.subnet_map
  tags_name  = "${var.project}-subnet-${var.env}"
}

#------------------------------
# route_table <public>
#------------------------------


#------------------------------
# route_table <private>
#------------------------------


#------------------------------
# igw
#------------------------------
module "igw" {
  source = "../../modules/network/igw"
  vpc_id = module.vpc_dev.vpc_id
  tags   = "${var.project}-igw"
}