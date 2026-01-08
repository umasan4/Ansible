# ターゲットノード セットアップ手順

## ※ 前提条件
  - OS：AlmaLinux 9.x で構築した
  - ユーザー：`ans`(sudo 権限あり) を作成して操作する
  - VMへの接続方法はNAT(VMnet8)

----------------------------------------
## ① 現在のネットワーク確認
  ### VM側で確認
  ```bash
  nmcli device status
  nmcli connection show
  ```

  ### ホスト側で確認（Windows）
  ```powershell
  ipconfig /all
  # NATの場合は、ホスト側のVMnet8が基準になる
  # VMnetのDHCPは無効にしておく
  ```
----------------------------------------
## ② 固定IPの設定 (nmcli)
  ### 両者のDGW,IPセグメントを揃える

  >nmcliコマンドが長いので Bashスクリプトを用意した（RHEL8以降専用）
  >./scripts/vNIC_setup.sh

  ```bash
  # 固定IPを割り当てる
  sudo nmcli connection modify <interface> \
  ipv4.addresses <ipaddr>/24 \ 
  ipv4.gateway <gateway_ipaddr> \
  ipv4.dns "8.8.8.8 <gateway_ipaddr>" \ # 仮想NWエディタ上のデフォルト値を設定する
  ipv4.method manual \
  ipv4.never-default no \
  connection.autoconnect yes

  # 設定を反映
  sudo nmcli connection down <interface> && sudo nmcli connection up <interface>
  ```
----------------------------------------
## ④ VM ~ Host 間のPingを許可する
  > PowerShellを管理者権限で開いて実行
  ```powershell
  # ICMPを許可する
  New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
  ```

----------------------------------------
## ⑤ 設定確認
  ```bash
  ip route
  nmcli device show
  ping <gateway_ipaddr>
  ping <8.8.8.8>

  # ip route に default via <gateway_ipaddress> があること
  # Pingの疎通が確認できること
  ```

----------------------------------------
## ⑥ 必須パッケージのインストール
  ```bash
  sudo dnf -y update
  sudo dnf -y install python3 sudo vim chrony e2fsprogs util-linux openssh-server
  ```

----------------------------------------
## ⑦ SSH サービスの有効化
  ```bash
  sudo systemctl enable --now sshd
  sudo systemctl status sshd
  ```

----------------------------------------
## ⑧ Firewall の有効化
  ```bash
  sudo systemctl start firewalld
  sudo systemctl enable firewalld
  ```

----------------------------------------
## ⑨ Tera Term からの接続テスト
  ```properties
  ホスト: vm_ipaddr
  ポート: 22
  ユーザー: ans
  パスワード or 公開鍵認証
  ```

----------------------------------------
## ⑩ VMのポート転送を設定する
  ```bash
  # VMに割り当てられているSSHポートを確認する
  sudo ss -lntp | grep sshd

  # VMの仮想NWエディタからポート転送を設定する
  # workstation → 仮想NWエディタ → NAT設定 → ポート転送
  例) ホスト `192.168.65.10:2223` → VM `22`（node1）
  例) ホスト `192.168.65.20:2224` → VM `22`（node2）

  # 設定反映のため VMのNATを再起動する
  # 管理者権限で Powershellを開き以下のコマンドを実行する
  Restart-Service "VMware NAT Service"

  # 接続テスト(Cygwin → VM)
  ssh -p 2223 ans@127.0.0.1
  ssh -p 2224 ans@127.0.0.1
  ```
----------------------------------------
## ⑪ 鍵認証のセットアップ
>コントロールノードで `~/.ssh/id_ed25519.pub` を作成済みであること  

```bash
# ターゲットノードで作成したSSH用の公開鍵をコントロールノードに格納する
# SCPで /.ssh/authorized_keys/ に直で格納するとowner関係で鍵が使用できない
# そのため以下の手順で鍵の中身を移植する

# ターゲットノードで操作する
cd ~
mkdir .ssh && chmod 700 .ssh
touch /tmp/id.pub

# コントロールノードで操作する
scp -P 2223 ~/.ssh/id_ed25519.pub ans@127.0.0.1:/id.pub
scp -P 2224 ~/.ssh/id_ed25519.pub ans@127.0.0.1:/id.pub

# ターゲットノードで操作する
cat /tmp/id.pub >> ~/.ssh/authorized_keys
chomod 600 .ssh/authorized_keys
rm /tmp/id.pub

# コントロールノードで操作する
ssh -i ~/.ssh/id_ed25519 -p 2223 ans@127.0.0.1
ssh -i ~/.ssh/id_ed25519 -p 2224 ans@127.0.0.1

# ターゲットノードで操作する
# ~/.ssh/config に以下の内容を追記する
Host node1
  Hostname 127.0.0.1
  Port 2223
  User ans
  Identityfiel ~/.ssh/id_ed25519

Host node2
  Hostname 127.0.0.1
  Port 2224
  User ans
  Identityfiel ~/.ssh/id_ed25519

# 以降は、ssh node1 または ssh node2 で接続できる
```
----------------------------------------