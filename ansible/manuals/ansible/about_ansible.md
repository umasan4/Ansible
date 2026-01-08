# 1. Ansibleの特徴

- Ansibleは、ITインフラの構成管理やアプリケーションのデプロイを自動化するツール。最大の特徴は
**エージェントレス**
であること。  
対象サーバーに専用のソフトウェアをインストールする必要がなく、SSH接続だけで操作できる。

- Ansibleは **冪等性**
を備える。同じPlaybookを何度実行してもサーバーの状態が意図通りに保たれる。  
例えば「ファイルをコピーする」という処理を何度実行しても、既にコピー済みなら再度コピーはされない。

- 設定は **YAML形式**
で記述。可読性が高くシンプルな構文なので学びやすい。  
標準で多数のモジュールがあり、必要に応じてPythonなどでカスタムモジュールも追加できる。

------------------------------------------------------------------------

# 2. Ansibleの構成

Ansibleを構成する基本要素は以下の通り。

-   **inventory**\
    管理対象となるサーバー一覧を定義するファイル。`hosts`や独自の`inventory`ファイルを使って対象ホストのIPやホスト名を管理する。

    ```ini
    [targets]
    node1 ansible_host=127.0.0.1 ansible_port=2222 ansible_user=ans ansible_connection=ssh ansible_python_interpreter=/usr/bin/python3

    node2 ansible_host=127.0.0.1 ansible_port=2223 ansible_user=ans ansible_connection=ssh ansible_python_interpreter=/usr/bin/python3
    ```

-   **Playbook**\
    実行内容を記述したファイル。YAML形式で「どのサーバーに」「どんなタスクを」実行するかを定義。Playbookは「サマリ部（対象や概要）」と「タスク部（具体的処理）」の2部構成。

-   **モジュール**\
    実際の作業を行う部品。例：`service`モジュールはサービスの起動・停止、`copy`モジュールはファイルコピー。

-   **ロール**\
    Playbookを役割ごとに整理する仕組み。例：「Webサーバー構築ロール」「DBサーバー構築ロール」に分けることで再利用性と可読性が向上。

-   **ディレクトリ構成**\
    ディレクトリの構成例
    ```bash
    ~/ansible/
    ├─ ansible.cfg        # Ansible の全体設定
    ├─ inventory.ini      # 管理対象ノード一覧
    ├─ group_vars/        # グループ共通変数
    │   └─ all.yml
    ├─ host_vars/         # ホスト個別変数
    │   ├─ node1.yml
    │   └─ node2.yml
    └─ site.yml           # メインのプレイブック
    ```

------------------------------------------------------------------------

# 3. Ansibleの使い方

Ansibleの基本的な使い方は次の通り。

- **準備**\
    管理対象のサーバー（例：AWS
    EC2）を用意し、管理ノードにAnsibleをインストール。

- **Playbook作成**\
    インベントリを指定し、YAML形式で処理内容を記述。タスクはモジュールを使って定義。

- **実行と確認**\
    `ansible-playbook` コマンドでPlaybookを実行。結果は以下の通り。

    -   `ok`：成功（変更なし）\
    -   `changed`：成功（変更あり）\
    -   `failed`：失敗\
    -   `skipped`：スキップ