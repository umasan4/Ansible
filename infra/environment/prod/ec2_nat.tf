#------------------------------
# vars
#------------------------------
locals {
  # subnet id だけのリストを作成
  subnet_public_id_list = values(module.subnet_public.subnet_public_ids)
}

#------------------------------
# ec2
#------------------------------
module "nat" {
  source    = "../../modules/compute/ec2"
  tags_name = "${var.project}-${var.env}"

  # instance
  ami_id        = data.aws_ami.fck_nat.id
  instance_type = "t4g.nano"
  key_name      = var.key_name

  # instance_map
  instances = {
    "nat" = "nat"
  }

  # security
  subnet_id              = local.subnet_public_id_list[0]
  vpc_security_group_ids = [aws_security_group.nat.id]
  iam_instance_profile   = aws_iam_instance_profile.nat.name

  # nat_option
  source_dest_check           = false # 他宛てのパケットをドロップする?
  associate_public_ip_address = true  # パブリックIPアドレスが必要か?
}

#------------------------------
# ami
#------------------------------
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
# eip
#------------------------------
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${var.project}-${var.env}-eip" }
}

# eip association
resource "aws_eip_association" "nat" {
  allocation_id = aws_eip.nat.id
  instance_id   = module.nat.instance_ids["nat"]
}

#------------------------------
# iam
#------------------------------
# ec2に渡す値は、aws_iam_instance_profile

# instance profile
resource "aws_iam_instance_profile" "nat" {
  name = "${var.project}-${var.env}-iam_instance_profile-nat"
  role = aws_iam_role.nat_prod.name
  tags = { Name = "${var.project}-${var.env}-iam_instance_profile-nat" }
}

# policy_attachment ( ec2(ssm agent) ⇔ ssm )
resource "aws_iam_role_policy_attachment" "nat" {
  role       = aws_iam_role.nat_prod.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# role
resource "aws_iam_role" "nat_prod" {
  name = "${var.project}-${var.env}-iam_role-nat"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = { Name = "${var.project}-${var.env}-iam_role-nat" }
}

#------------------------------
# sg
#------------------------------
resource "aws_security_group" "nat" {
  name   = "${var.project}-${var.env}-nat_sg"
  vpc_id = module.vpc.vpc_id

  # ingress / [192.168.0.0/16] all
  ingress {
    description = "Allow sg to sg connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # egress / allow all
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # note:-1...すべて許可
  # note: 1...Pingのみ許可

  tags = { Name = "${var.project}-${var.env}-nat_sg" }
}