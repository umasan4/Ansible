#------------------------------
# vars
#------------------------------
locals {
  # subnet id だけのリストを作成
  subnet_id_list = values(module.subnet_dev.subnet_ids)
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
  subnet_id              = local.subnet_id_list[0]
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
  tags   = { Name = "${var.project}-eip-${var.env}" }
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
  name = "${var.project}-iam_instance_profile-nat-${var.env}"
  role = aws_iam_role.nat.name
  tags = { Name = "${var.project}-iam_instance_profile-nat-${var.env}" }
}

# policy_attachment ( ec2(ssm agent) ⇔ ssm )
resource "aws_iam_role_policy_attachment" "nat" {
  role       = aws_iam_role.nat.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# role
resource "aws_iam_role" "nat" {
  name = "${var.project}-iam_role-nat-${var.env}"

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
  tags = { Name = "${var.project}-iam_role-nat${var.env}" }
}

#------------------------------
# sg
#------------------------------
resource "aws_security_group" "nat" {
  name   = "${var.project}-nat_sg-${var.env}"
  vpc_id = module.vpc_dev.vpc_id

  # ingress / [192.168.0.0/16] all
  ingress {
    description = "Allow sg to sg connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"]
  }

  # egress / allow all
  egress {
    description = "Allow all outbound taffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # note:-1...すべて許可
  # note: 1...Pingのみ許可

  tags = { Name = "${var.project}-nat_sg-${var.env}" }
}