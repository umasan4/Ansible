# systax:

## inventory
```properties
# ansible-playbook は -i オプションでインベントリファイルを指定する
例: ansible-playbook -i <inventory> <playbook>
例: ansible-playbook -i inventory.ini create_files.yml
```

## register
```yml
# registerとは
  # 意味: タスクの実行結果を変数に格納する仕組み
  # 用途: 後続の処理で条件分岐やデバックに使用する
  # 例: task1のregisterが [T => task2 / F => task3]

# 注意点: registerは辞書型を返すため、どの中身を受け取るか以下の指定が必要
rc: コマンドの終了コード（0なら成功）
msg: モジュールからのメッセージ（エラーや警告など）
delta: 実行時間（秒）
changed: タスクで変更が発生したか（true / false）
failed: タスクが失敗したか（true / false）
stdout: 標準出力（文字列）
stdout_lines: 標準出力を行単位で分割したリスト
stderr: 標準エラー出力（文字列）
stderr_lines: 標準エラー出力を行単位で分割したリスト
warnings: 警告メッセージ（リスト）
invocation: 実行されたモジュールやパラメータ情報
start / end: タスク開始・終了時刻
failed_when_result: failed_when 条件評価結果

# 例: NTPクライアントの同期状態の確認
- name: クライアントの同期状態を確認
  hosts: ntp_client
  become: yes
  tasks:
    - name: chronyc sources
      ansible.builtin.command: chronyc sources # 同期状態を表示
      register: chronyc_sources

    - name: 結果を表示
      ansible.builtin.debug:
        var: chronyc_sources.stdout_lines # 結果を取得
```

## 特殊変数
```properties
inventory_hostname : inventory.ini のホスト名を返す
ansible_hostname   : 実環境に設定されたホスト名を返す
```