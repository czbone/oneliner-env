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

## Webサーバ(LEMP)環境構築 (所要時間: 約10分)
Linux(L),Nginx(N),MariaDB(M),PHP(P)のLEMP環境を作成します。
PHPはバージョン7.3です。

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp.sh | sh
```
## 動画配信サーバ(LEMP+FFmpeg)環境構築 (所要時間: 約1時間)
LEMP環境作成後、必要なライブラリを集めて最新のFFmpegのビルド処理を行います。FFmpegのコンパイルには時間がかかります。

FFmpegはコーデックにAV1やh265等に対応しています。その他のFFmpegの設定は[こちら](https://github.com/czbone/oneliner-env/blob/master/ffmpeg_spec.txt )を参照してください。

###バージョン
- PHP 7.3
- FFmpeg 4.1

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp_ffmpeg.sh | sh
```

# 検証環境
- Vagrant Box 「centos/7」
- さくらVPS 「CentOS7」
