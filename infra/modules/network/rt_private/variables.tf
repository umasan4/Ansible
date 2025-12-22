#------------------------------
# route table private
#------------------------------
variable "vpc_id" { type = string }
variable "eni_id" { type = string }
variable "tags_name" { type = string }

#------------------------------
# route table association private
#------------------------------
variable "subnet_ids" {
  description = "subnet outputs (key: name / value: id)"
  type = map(string)
}

#------------------------------
# network interface (eni_id)
#------------------------------
# variable "eni_id" {
#   description = "nat instance eni id"
#   type = string
# }