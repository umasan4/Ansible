#------------------------------
# route table public
#------------------------------
variable "vpc_id" { type = string }
variable "igw_id" { type = string }
variable "tags_name" { type = string }

#------------------------------
# route table association public
#------------------------------
variable "subnet_ids" {
  description = "subnet outputs (key: name / value: id)"
  type        = map(string)
}