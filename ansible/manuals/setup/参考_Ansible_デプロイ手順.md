# はじめに

> ⚠️ **重要な注意事項**  
> 初期構築時に差分チェックを行うことは問題ありませんが、  
> **許可を得ずにデプロイを行うことは絶対に避けてください。**

---

# 本手順の概要

この手順書は、**Ansible環境構築後のデプロイ準備～デプロイ実行**までの流れを説明しています。  
Ansible環境が未構築の場合は、先に構築手順を確認してください。

元の手順：  
Slackリンク

---

# 【2】デプロイ準備～デプロイ実行まで

## Git資材側でのYML修正

### 1. リリース用YMLの修正（※①②は作成済みであれば不要）

- ① 修正対象ファイルを以下に記載。不要ファイルはコメント化  
  `roles/XXXX/vars/main.yml`

- ② 修正用rolesの作成  
  `roles/XXXX/tasks/main.yml`

- ③ rolesの呼び出し設定を以下に記載（既存rolesを触る場合は不要）  
  `ss_サーバー.yml`  
  ※ `ssw_サーバー.yml` などもあり

### 2. フォールバック用YMLの準備

- ① フォールバック対象を以下に記載  
  `roles/fb/YYYYMMDD/vars/main.yml`

- ② フォールバック用rolesの作成  
  `roles/fb/YYYYMMDD/tasks/main.yml`

- ③ rolesの呼び出し設定を以下に記載（※必須。`never`指定）  
  `ss_サーバー.yml`

---

## 修正例

- リリース日：2025/3/10  
- ブランチ：`issue391`  
- 修正ファイル：`/ssw/ap/infra/ini/logprune_daily_h031S3888.lst.1`

### 1. リリース用YMLの修正

- ① `/ansible/ssw/ap/roles/infra/vars/main.yml`  
  - `permissions:`、`ini_files:`、`/infra/ini/logprune_daily～` のみ有効化  
  - 他はコメントアウトでOK

- ② `/ansible/ssw/ap/roles/infra/tasks/main.yml`  
  - `name: copy ini files` のみ有効化  
  - 他はコメントアウトでOK

- ③ `/ansible/ssw/ap/ssw_ap.yml`  
  - `infra`タグは既に存在しているため追加不要

### 2. フォールバック用YMLの準備

- ① `/ansible/ssw/ap/roles/fb/20250310/vars/main.yml`  
  - 上記①で有効化した内容を記載

- ② `/ansible/ssw/ap/roles/fb/20250310/tasks/main.yml`  
  - 上記②で有効化した内容を記載

- ③ `/ansible/ssw/ap/ssw_ap.yml`  
  - `role: fb/20250310`  
  - `tags: fb_20250310` を追記（他のfb設定を参考）

---

## Cygwin上での操作

※Cygwin初期設定の `prod` / `dev` 状態を意識して実行すること

### 3. 差分ファイル作成

- ① 修正対象ファイルを以下に記載  
  `vars/diff_files.yml`

- ② 比較対象ブランチをclone  
  ```bash
  cd ~/gitlab/
  git clone https://devplf.resonabank.co.jp/resonaso/gitlab/agile-infra/group-app-new.git group-app-new-for-diff
  ```