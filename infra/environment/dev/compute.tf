data "aws_ami" "fck_nat" {
  most_recent = true
  owners      = ["568608671756"] # fck-natの公式アカウントID

  filter {
    name = "name"
    # Amazon Linux 2023ベース、ARM64(Graviton)用を指定
    values = ["fck-nat-al2023-*-arm64-ebs"]
  }
}