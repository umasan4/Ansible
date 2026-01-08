## losetup
```bash
# 基本構文
losetup [オプション] [loopデバイス] [ファイル]

# 割当て済デバイスを表示
losetup -j <file_path>

# 割当て済デバイスを表示（全表示)
losetup -a

# 空きデバイスを自動割当て
losetup -f <file_path>

# 割当て済デバイスを削除
sudo losetup -d <disk_name>

# 割当て済デバイスを削除（全削除）
sudo losetup -D
```

## mkfs
```bash
# 基本構文
mkfs [オプション] [ファイルシステムタイプ] [デバイス]

# 例: ext4ファイルシステムを作成
sudo mkfs.ext4 /dev/loop0
```

## fallocate
```bash
# 指定サイズのファイルを作成する
# 仮想マシンに追加する仮想ディスクとして使用する

# 例: 100mbyte のファイル作成
fallocate -l 100M /tmp/common.img
  引数1： -l (小文字エル)...サイズと単位を指定(100M)
  引数2： 作成したファイルの格納先を指定
```