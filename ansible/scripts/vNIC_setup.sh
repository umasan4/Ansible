#!/bin/bash
#--------------------
# objective
#--------------------
# 対話形式でネットワーク設定を行う

#--------------------
# variables
#--------------------
declare -a ar
log="/$HOME/network_config.log"
active_if=$(nmcli device show | grep GENERAL.DEVICE | cut -d ":" -f 2 | xargs)

# nwif
echo "0) 変更対象のNWインターフェースを指定する"
echo "ヒント: 指定可能なインターフェース: ${active_if}"
read nwif

# ipv4.addr
echo "1) ipv4アドレスを指定する"
echo "IPアドレスのみ入力する、サブネットは不要(/24など)"
read ipv4_addr

echo "2) ipv4アドレスのサブネットを指定する"
echo "先頭のスラッシュ(/)は不要、数値のみ入力"

while true; do
        read ipv4_subnet
        if [[ "$ipv4_subnet" =~ ^[0-9]+$ ]]; then
                break
        else
                echo "エラー: 数値のみを入力する。再入力:"
        fi
done

# gateway
echo "3) デフォルトゲートウェイを指定する"
read ipv4_dgw

# dns
echo "4) DNSサーバを指定する(1台目)"
read ipv4_dns1

echo "5) DNSサーバを指定する(2台目)"
read ipv4_dns2

ar[0]="${nwif}"
ar[1]="${ipv4_addr}"
ar[2]="${ipv4_subnet}"
ar[3]="${ipv4_dgw}"
ar[4]="${ipv4_dns1}"
ar[5]="${ipv4_dns2}"

# main
sudo nmcli connection modify "${ar[0]}" \
ipv4.addresses "${ar[1]}/${ar[2]}" \
