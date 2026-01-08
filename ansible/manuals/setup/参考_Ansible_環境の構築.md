# 🚀 Ansible環境構築手順（ローカル）

> ⚠️ **注意事項**  
> 初期構築時に差分チェックまではOKですが、**許可なくデプロイは絶対に行わないでください。**

---

## 📌 前提条件

- Gitで作業ブランチ（issue等）を作成し、push済みであること
- Git環境が未構築の場合は以下の資料を参照：

### 🔗 関連資料

- `Box\ReDI_アジャイル基盤チーム\20.GitLab\00.概要・ルール\概要・ルール.xlsx`  
  → 各環境との関係図

- `Box\ReDI_アジャイル基盤チーム\20.GitLab\10.利用方法等\vscodeからの利用方法.xlsx`  
  → VSCodeインストールとproxy設定

- `Box\ReDI_アジャイル基盤チーム\20.GitLab\10.利用方法等\Git運用手順.xlsx`  
  → ブランチ作成・MR作成などの運用手順

---

## 🛠️ 【1】ローカルにAnsible環境構築

### 1. PortableCygwinの導入

```text
Box\ReDI_アジャイル基盤チーム\12.PortableCygwin\
├─ readme-groupapp.md
├─ PortableCygwin_v1.0.zip
└─ Data_Grapp.zip
```

手順
PortableCygwin_v1.0.zip を Cドライブ直下に保存・解凍
cygwin-portble-setup.cmd をダブルクリックしてセットアップ開始
Data_Grapp.zip を解凍し、PortableCygwin/Data にコピー
※ admin フォルダとして解凍された場合 → Data/admin にコピー
2. Ansibleインストール

🔧 Git初期設定とリポジトリクローン
1. 設定ファイル編集
編集対象：Data/admin/ansible/git/vars/git_vars.yml, proxy_vars.yml

git_vars.yml の補足

2. リポジトリクローン

実行後、以下にブランチが作成される：

PortableCygwin_v1.0/Data/admin/gitlab/group-app-new
└─ issuexxx（作業ブランチ）
🔐 接続先/認証情報の初期設定

✅ 補足
差分チェック前に接続先/認証情報の初期設定まで完了している必要があります。
デプロイは必ず許可を得てから実施してください。