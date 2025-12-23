locals {
  # subnet id
  subnet_id_list = values(module.subnet_dev.subnet_ids)
}

#------------------------------
# ec2 / nat
#------------------------------
# instance
module "nat" {
  source    = "../../modules/compute/ec2"
  tags_name = "${var.project}-nat-${var.env}"

  # machine
  ami_id        = data.aws_ami.fck_nat.id
  instance_type = "t4g.nano"
  key_name      = var.key_name

  # security
  subnet_id              = local.subnet_id_list[0]
  vpc_security_group_ids = [aws_security_group.nat.id]
  iam_instance_profile   = aws_iam_instance_profile.nat.name

  # nat_option
  source_dest_check           = false
  associate_public_ip_address = true
}

# eip
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${var.project}-eip-${var.env}" }
}

# eip association
resource "aws_eip_association" "nat" {
  allocation_id = aws_eip.nat.id
  instance_id   = module.nat.instance_id
}

# ami
data "aws_ami" "fck_nat" {
  most_recent = true
  owners      = ["568608671756"] # fck-natの公式アカウントID

  filter {
    name = "name"
    # Amazon Linux 2023ベース、ARM64(Graviton)用を指定
    values = ["fck-nat-al2023-*-arm64-ebs"]
  }
}

#------------------------------
# ec2 / control_node
#------------------------------