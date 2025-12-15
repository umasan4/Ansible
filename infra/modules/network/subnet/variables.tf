#------------------------------
# env
#------------------------------
variable "tags_name" { type = string }

#------------------------------
# subnet
#------------------------------
variable "vpc_id" { type = string }

variable "subnet_map" {
  description = "{key:name = value:cidr}"
  type        = map(string)

  # 宣言例: 
  # subnet_map = {
  #  "dev"  = "192.168.0.0/24"
  #  "prod" = "192.168.1.0/24"
  # }
}