resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name

  tags = { Name = var.tags_name }

  # nat instance only
  associate_public_ip_address = var.associate_public_ip_address
  source_dest_check           = var.source_dest_check
  user_data                   = var.user_data
}