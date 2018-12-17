# 1行で環境構築
サーバにrootログインし１行のコマンドを実行するだけで環境構築できるスクリプトです。
必要なソフトウェアがすべて1台のサーバに納まるようにパッケージ化された環境を作ります。
環境構築は難しい、たいへん時間がかかるという問題を解決します。

このプロジェクトは、正確に動作するごく標準的な環境を構築するのを目的としています。
それ以上の環境が必要な場合は、出来た環境からさらに独自のカスタマイズを行うのがベターです。

## 対象OS
- CentOS 7

## ライセンス

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

# 実行内容
ローカルにAnsibleをインストールし、Ansible GalaxyのPlaybookを基本に少しカスタマイズして環境構築しています。
次の特色があります。

- 最新のソフトウェア環境
- 日本語最適化

# 使い方
新規にOSをインストールしたサーバにrootでログインし、構築したい環境のスクリプトを実行します。
完了後は一旦サーバを再起動してください。

## LEMP環境構築 (所要時間: 約10分)
Linux(L),Nginx(N),MariaDB(M),PHP(P)のLEMP環境を作成します。
PHPはバージョン7.3です。

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp.sh | sh
```
## LEMP+FFmpeg環境構築 (所要時間: 約1時間)
Linux(L),Nginx(N),MariaDB(M),PHP(P)のLEMP環境作成後、必要なライブラリを集めてFFmpegのビルド処理を行います。FFmpegのコンパイルに時間がかかります。
PHPはバージョン7.3です。
その他のFFmpegの設定は[こちら](https://github.com/czbone/oneliner-env/blob/master/ffmpeg_spec.txt )です。

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp_ffmpeg.sh | sh
```

# 検証環境
- Vagrant Box 「centos/7」
- さくらVPS 「CentOS7」
