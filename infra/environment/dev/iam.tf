#------------------------------
# iam / nat
#------------------------------
# note: ec2に渡す値は、aws_iam_instance_profile

# instance profile
resource "aws_iam_instance_profile" "nat" {
  name = "${var.project}-iam_instance_profile-nat-${var.env}"
  role = aws_iam_role.nat.name
  tags = { Name = "${var.project}-iam_instance_profile-nat-${var.env}" }
}

# policy_attachment ( ec2(ssm agent) ⇔ ssm )
resource "aws_iam_role_policy_attachment" "ssm_core" {
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
# iam role & policy / cotrol_node
#------------------------------
# # iam_policy (policy ⇔ attchment)
# 目的: ec2(controle_node) ⇔ s3(playbook)
# resource "aws_iam_role_policy_attachment" "s3_read" {
#   role       = aws_iam_role.nat.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }