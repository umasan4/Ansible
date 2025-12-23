#------------------------------
# ec2
#------------------------------
module "target" {
  source    = "../../modules/compute/ec2"
  tags_name = "${var.project}-${var.env}"

  # instance
  ami_id        = data.aws_ami.target.id
  instance_type = "t4g.nano"
  key_name      = var.key_name

  # instance_map
  instances = {
    "target1" = "target1"
    "target2" = "target2"
  }

  # security
  subnet_id              = local.subnet_id_list[1]
  vpc_security_group_ids = [aws_security_group.target.id]
  iam_instance_profile   = aws_iam_instance_profile.target.name
}

#------------------------------
# ami
#------------------------------
# target nodeにはAmazon Linux 2023を選択
# 理由: Python 3 が標準搭載
# 理由: SSM Agentが標準搭載

data "aws_ami" "target" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

#------------------------------
# iam
#------------------------------
# ec2に渡す値は、aws_iam_instance_profile

# instance profile
resource "aws_iam_instance_profile" "target" {
  name = "${var.project}-iam_instance_profile-target-${var.env}"
  role = aws_iam_role.target.name
  tags = { Name = "${var.project}-iam_instance_profile-nat-${var.env}" }
}

# policy_attachment ( ec2(ssm agent) ⇔ ssm )
resource "aws_iam_role_policy_attachment" "target" {
  role       = aws_iam_role.target.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# role
resource "aws_iam_role" "target" {
  name = "${var.project}-iam_role-target-${var.env}"

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
  tags = { Name = "${var.project}-iam_role-target${var.env}" }
}

#------------------------------
# sg
#------------------------------
resource "aws_security_group" "target" {
  name   = "${var.project}-target_sg-${var.env}"
  vpc_id = module.vpc_dev.vpc_id

  # コントロールノードからのSSH許可
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # NAT経由で外に出るため
  egress {
    description = "Allow all outbound taffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # note:-1...すべて許可
  # note: 1...Pingのみ許可

  tags = { Name = "${var.project}-target_sg-${var.env}" }
}
