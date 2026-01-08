# Playbook一覧

## setup_chrony.yml
node1を NTPサーバに、  
node2を NTPクライアントに設定する

## setup_cron.yml
cron job を作成する  
1分毎に `date` を実行する  
結果を `/tmp/ansible_cron.log` に格納する

## create_files.yml
ターゲット間で同名と固有名のファイルを作成する

## create_filesystems.yml
ターゲット間で同名と固有名のファイルシステムを作成する

## install_package.yml
ターゲットに必要なパッケージをインストールする

