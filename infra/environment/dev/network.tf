#------------------------------
# vpc
#------------------------------
module "vpc" {
  source      = "../../modules/network/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_tenancy = var.vpc_tenancy
  tags_name   = "${var.project}-${var.env}-vpc"
}

#------------------------------
# igw
#------------------------------
module "igw" {
  source    = "../../modules/network/igw"
  vpc_id    = module.vpc.vpc_id
  tags_name = "${var.project}-${var.env}-igw"
}

#------------------------------
# subnet
#------------------------------
module "subnet_public" {
  source         = "../../modules/network/subnet_public"
  vpc_id         = module.vpc.vpc_id
  subnets_public = var.subnets_public
  tags_name      = "${var.project}-${var.env}"
}

module "subnet_private" {
  source          = "../../modules/network/subnet_private"
  vpc_id          = module.vpc.vpc_id
  subnets_private = var.subnets_private
  tags_name       = "${var.project}-${var.env}"
}

#------------------------------
# rt
#------------------------------
module "rt_public" {
  source            = "../../modules/network/rt_public"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.igw.igw_id
  public_subnet_ids = module.subnet_public.subnet_public_ids
  tags_name         = "${var.project}-${var.env}-rt_public"
}

module "rt_private" {
  source             = "../../modules/network/rt_private"
  vpc_id             = module.vpc.vpc_id
  eni_id             = module.nat.network_interface_ids["nat"]
  private_subnet_ids = module.subnet_private.subnet_private_ids
  tags_name          = "${var.project}-${var.env}-rt_private"
}