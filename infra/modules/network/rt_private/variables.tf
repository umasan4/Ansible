#------------------------------
# route table private
#------------------------------
variable "vpc_id" { type = string }
variable "eni_id" { type = string }
variable "tags_name" { type = string }

#------------------------------
# route table association private
#------------------------------
variable "private_subnet_ids" {
  description = "subnet outputs (key: name / value: id)"
  type        = map(string)
}