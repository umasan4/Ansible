#------------------------------
# tags
#------------------------------
variable "env" { type = string }
variable "project" { type = string }

#------------------------------
# vpc
#------------------------------
variable "vpc_cidr" { type = string }
variable "vpc_tenancy" {
  type    = string
  default = "default"
}

#------------------------------
# subnet
#------------------------------
variable "subnets_public" {
  description = "{key:name = value:cidr}"
  type        = map(string)

  # 宣言例: 
  # public_subnets = {
  #  "dev"  = "192.168.0.0/24"
  #  "prod" = "192.168.1.0/24"
  # }
}

variable "subnets_private" {
  description = "{key:name = value:cidr}"
  type        = map(string)
}

#------------------------------
# ec2 / nat
#------------------------------
variable "key_name" { type = string }