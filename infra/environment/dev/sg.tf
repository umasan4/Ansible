#------------------------------
# sg / nat_instance
#------------------------------
resource "aws_security_group" "nat" {
  name   = "${var.project}-nat_sg-${var.env}"
  vpc_id = module.vpc_dev.vpc_id

  # ingress / allow all
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

#------------------------------
# sg / control_node
#------------------------------