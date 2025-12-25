output "subnet_public_ids" {
  description = "subnet_IDを抽出したmapを作成"
  value       = { for key, value in aws_subnet.public : key => value.id }

  # メモ
  # => は区切り文字
  # 左をkey => 右をvalueにする

  # 作成されるmap例:
  # {
  #   "dev"  = "subnet-0xyz7777",
  #   "prod" = "subnet-01234abcd"
  # }

  # 値の取り出し例:
  # subnet_ids = { "dev" = module.subnet_main.subnet_ids["dev"] }
  # subnet_ids = { "prod" = module.subnet_main.subnet_ids["prod"] }
}