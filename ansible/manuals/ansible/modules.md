# modules:

## ファイル系

### file
```yaml
# ファイルもしくはディレクトリを作成する
path  : 対象のパス
state : 対象はファイル or ディレクトリ
mode  : パーミッション(例: 644など)
owner : 所有者
group : グループ
src   : リンク作成時のリンク先(シンボリック or ハード)
```

### lineinfile
```yaml
# ファイル内の特定の行を変更・削除・追加する
path   : 対象のパス
line   : 行の内容
regexp : 置換対象を探すための正規表現
state  : present(追加/置換) or absent(削除)
create : 対象のファイルが無ければ作成する(yes/no) 
backup : 編集前にバックアップを取る(yes/no)
```

## ストレージ系 

### mount
```yaml
# デバイスを指定したマウントポイントにマウントする
path   : マウントポイントのディレクトリ
src    : デバイスのパス
fstype : ファイルシステムタイプ
state  : mounted, unmounted, present, absent
opts   : マウントオプション(defaultなど) 

# state: に指定できるパラメタ
       # present   : fstabに登録のみ
       # mounted   : fstabに登録 + マウント
       # unmounted : アンマウントのみ
       # absent    : fstabから削除 + アンマウント
```

### filesystem
```yaml
# デバイスのファイルシステムを作成
dev      : ファイルシステムを作成する対象
fstype   : ファイルシステムタイプ
force    : 既存のファイルシステムを上書きするか (yes/no)
         # 冪等性を確保するなら、force: no を指定する
opts     : mkfs コマンドに渡す追加オプション
resizefs : 既存のファイルシステムをリサイズするか (yes/no)
         # yesにすると、ファイルシステムがパーティションいっぱいに拡張される
```

## サービス・パッケージ系

### package
```yaml
# パッケージの導入 or 削除
name    : パッケージ名 
present : present(追加/置換) or absent(削除) ※忘れがち
```

### service
```yaml
# サービスを状態を操作する
# 起動・停止・再起動, enable/disable
name  : サービス名
state : 移行させる状態（例 started）
```

### service_facts
```yaml
# サービスの情報収集
# ターゲットノード上の全サービス一覧と状態を取得する
# 実行すると、ansible_facts.services という辞書に格納される

- name: Collect service facts
  ansible.builtin.service_facts:
  # ↑ モジュールを宣言するだけ、後続のdebugやassertで情報を参照するために使われる

- name: Show service state
  ansible.builtin.debug:
    var: ansible_facts.services['apache2'].state
    # apacheの稼働状態を確認できる(running, stopped等が返ってくる)

# 例: ansible_facts.servicesの中身の一部イメージ
apache2:
  name: apache2
  state: running      # ← これが .state
  status: enabled     # 自動起動設定
  source: systemd     # 管理システム
```

## 条件分岐・ループ系

### assert
```yaml
# ansible版の if文

# 基本構文
- name: Assert example
  ansible.builtin.assert:
    that:
      - "条件式1"
      - "条件式2"
    fail_msg: "条件を満たしていません"
    success_msg: "条件を満たしました"

# 例: apacheの状態を確認し、それに応じたmsgを送信する
- name: assert apache is running
  ansible.builtin.assert:
    that:
     - "apache2 in ansible_facts.services"
     - "ansible_facts.services['apache2'].state == 'running'"
    fail_msg: "Apache is NOT running!"
    success_msg: "Apache is running."

```

### template(重要)
```yaml
j2ファイルを使う

# 例: ファイルを作成する
# ntp_server / node1
{% if ntp.is_server %}
hostname = {{ inventory_hostname }}
{% endif %}

# ntp_client / node2
{% if ntp.is_client %}
hostname = {{ inventory_hostname }}
{% endif %}

```

### shell, command
```properties
Ansible上でLinuxコマンドを実行するモジュール
注意点として、Ansibleの最大のメリットである冪等性を持たない
args(～がある場合スキップ)やif文を書いてこちらで冪等性を確保する必要がある
```