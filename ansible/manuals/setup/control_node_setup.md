# 1. Control_node_setup手順

## ※ 前提条件
  - Cygwin/Python 3.9/virtualenv を使用する  
  - Cygwinは、Ansible公式から動作保証されていない (WSL2を推奨)
  - Cygwinは、一部のPythonライブラリが動作しない (Rust系)  
  - Rust不要のバージョンに固定したPyton仮想環境(virtualenv)を用意する

----------------------------------------
## 1. 事前準備（Cygwin パッケージ）
  ### `setup-x86_64.exe` で以下を追加する（GUI）  
  ```bash
  # インストール
  python3
  python3-pip
  openssh
  gcc-core
  make
  python39-devel # または python3-devel（見える方）
  libyaml-devel
  pkg-config
  vim
  bash-completion # Ansibleコマンドのtab補完
  tree            # dir構造の可視化
  git
  
  # インストールできたか確認
  which gcc make
  python --version
  ```
----------------------------------------
## 2. virtualenv を用意する
  > ここからは Cygwin ターミナル（CLI）で操作する

  ### ①. virtualenv をインストールする
  ```bash
  # インストール
  python3 -m pip install --user virtualenv

  # インストールできたか確認
  python3 -m virtualenv --version
  ```

  ### ②. Ansible 用の仮想環境を作成する
  ```bash
  # 仮想環境：ansibleを作成する
  python3 -m virtualenv ~/venvs/ansible

  # 仮想環境に入る（プロンプトに ansible と付けばOK)
  source ~/venvs/ansible/bin/activate

  # エイリアスを作成する
  echo 'alias av="source ~/venvs/ansible/bin/activate"' >> ~/.bashrc
  source ~/.bashrc

  # 次回から、av とタイプすれば仮想環境に入れる、抜けるには deactivate
  ```
  >以降の手順は仮想環境に入ったまま実行する

  ### ③. pip 更新 & Ansible 本体
  ```bash
  python -m pip install --upgrade pip wheel
  python -m pip install --no-deps ansible-core==2.15.13
    # --no-deps：依存関係を手動解決する、CygwinがRustに対応できないため
    # ansible-core==2.15.13：Python3.9対応の安定版

  python -m pip install yamllint
    # ymallint...YAMLの構文チェックツール
    # 使い方1: yamllint <yamlファイル> ... 指定ファイルのYAML構文をチェックする
    # 使い方2: yamllint .             ... カレントのYAMLファイルの構文全てチェック
  ```

  ### ④. Rust不要の依存パッケージをインストール
  ```bash
  # Cygwinが古く対応できないため古いバージョンを指定
  python -m pip install \
    "jinja2==3.1.6" "MarkupSafe==2.1.5" \
    "PyYAML==6.0.2" "packaging==24.2" "resolvelib==1.0.1" \
    "jsonschema==4.17.3" "pyrsistent==0.19.3" "attrs==23.2.0" \
    "importlib-resources==5.0.0"
  ```

  ### ⑤. 動作確認
  ```bash
  ansible --version
  python -c "import ansible, jinja2, yaml, jsonschema, importlib_resources; print('deps ok')"
  # deps ok が出力されたらOK
  ```

----------------------------------------
## 3. 各種設定
  ### ①. config ファイルを作成する

  ```bash
  mkdir -p ~/ansible && cd ~/ansible
  cat > ansible.cfg <<'EOF'
  [defaults]
  inventory = ./inventory.ini
  host_key_checking = False
  interpreter_python = auto_silent
  timeout = 30
  ansible_ssh_private_key_file=/home/<user>/.ssh/id_ed25519 
  # <usre>: コントロールノード側のユーザ名

  [ssh_connection]
  ssh_args = -o ControlMaster=no -o ControlPersist=0
  EOF
  ```

  ### ②. inventory ファイルを作成する
  ```ini
  cd ~/ansible
  touch inventory.ini

  # inventoryファイルを開く
  vim inventory.ini

  # inventoryファイルに以下を追記する
  [targets]
  node1 ansible_host=127.0.0.1 ansible_port=2222 ansible_user=ans ansible_connection=ssh ansible_python_interpreter=/usr/bin/python3
  node2 ansible_host=127.0.0.1 ansible_port=2223 ansible_user=ans ansible_connection=ssh ansible_python_interpreter=/usr/bin/python3

  # IPアドレス, ポート番号, 鍵パスは接続先に応じて変更する
  # この時点では接続できないため、接続テストは不要
  ```

  ### ③. SSH接続用の非対称鍵を作成
  ```bash
  # 作成
  ssh-keygen -t ed25519 -C "Ansible-ControleNode"

  # 権限を変更
  chmod 700 ~/.ssh
  chmod 644 ~/.ssh/id_ed25519.pub
  chmod 400 ~/.ssh/id_ed25519
  ```
## 4. Ansible セットアップ
  ### ①. ansible.cfg
  ```ini
  [defaults]
  inventory = ./inventory.ini
  host_key_checking = False
  interpreter_python = auto_silent
  timeout = 30
  ```

  ### ②. inventory.ini
  ```yml
all: 
  children: 
    ntp_server:
      hosts:
        node1: 
          ansible_host: 127.0.0.1
          ansible_port: 2223
          ansible_user: ans
          ansible_connection: ssh
          ansible_ssh_private_key_file: /home/User/.ssh/id_ed25519 # SSH接続用の秘密鍵
          ansible_python_interpreter: /usr/bin/python3 # python3を使用
    ntp_client:
      hosts:
        node2:
          ansible_host: 127.0.0.1
          ansible_port: 2224
          ansible_user: ans
          ansible_connection: ssh
          ansible_ssh_private_key_file: /home/User/.ssh/id_ed25519
          ansible_python_interpreter: /usr/bin/python3
  ```

  ### ③. 接続テスト
  ```bash
  ssh -p 2223 ans@127.0.0.1 -o StrictHostKeyChecking=no exit
  ssh -p 2224 ans@127.0.0.1 -o StrictHostKeyChecking=no exit

  ansible -i inventory.yml targets -m ping
  ```