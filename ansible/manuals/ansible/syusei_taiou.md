# 修正対応した内容メモ

--------------------------------------------------
## コントロールノード

- ansible-vault 利用断念  
Cygwinが古すぎて `cryptography` ビルドエラー多発のため  

- コマンド短縮  
.bashrc にエイリアス登録`alias ap='ansible-playbook`
  
- モジュール不足対応  
  `ansible.posix.firewalld` が見つからない →
  ```bash
  ansible-galaxy collection install ansible.posix
  ```

--------------------------------------------------
## ターゲットノード

- sudoパスワード省略  
  `sudo visudo` で Ansibleユーザー `ans` に:
  ```
  ans ALL=(ALL) NOPASSWD: ALL
  ```

- SSH遅延対策  
  `/etc/ssh/sshd_config` に以下を設定した
  ```ini
  UseDNS no
  # 接続元IPを逆引きしてホスト名を確認し、ログに記録するための機能
  # 逆引きDNSは信頼性が低く、パフォーマンスに悪影響 → 無効化がベストプラクティス
  ```
  → `sshd` 再起動

- firewalld起動  
  Ad-Hocコマンドで起動:
  ```bash
  ansible node1 -m command -a "systemctl start firewalld"
  ```

--------------------------------------------------
## Playbook

- YAMLインデント  
  - Tab禁止
  - Space 2文字推奨