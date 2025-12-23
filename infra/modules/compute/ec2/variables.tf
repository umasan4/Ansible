#------------------------------
# instance / common
#------------------------------
# machine
variable "instances" { type = map(string) }
variable "tags_name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
# security
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "vpc_security_group_ids" { type = list(string) }
variable "iam_instance_profile" { type = string }

#------------------------------
# instance / nat
#------------------------------
variable "associate_public_ip_address" {
  description = "need public ip ?"
  type        = bool
  default     = false # (NAT → true)
}

variable "source_dest_check" {
  description = "drop other ip ?"
  type        = bool
  default     = true # (NAT → false)
}

variable "user_data" {
  description = "nat instance booting script"
  type        = string
  default     = null
}