やること

- 2025年12月23日
1. compute (nat_instance)の作成

2. dev配下の整理(以下を参考に)

environment
└── dev
    ├── compute.tf         # EC2モジュールの「呼び出し」だけを書く
    ├── network.tf         # VPC, Subnetなどのモジュール呼び出し
    ├── security_group.tf  # ★新規作成: SGのリソース定義 (resource "aws_security_group")
    ├── iam.tf             # ★新規作成: IAMのリソース定義 (resource "aws_iam_...")
    ├── dev.tfvars
    ├── provider.tf
    └── variables.tf
※ network のsg は、security_group.tf に移動する
※ ファイルの粒度に差が出るがそろえる必要はない(vpc,subnet 等は役割がほとんど決まっているため)