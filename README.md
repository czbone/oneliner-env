# 1行で環境構築
サーバに`root`ログインし１行のコマンドを実行するだけで環境構築できるスクリプトです。  
必要なソフトウェアがすべて納まり、連携動作も取れている1台のサーバ環境を作ります。  
環境構築は難しい、たいへん時間がかかるという問題を即座に解決します。

このプロジェクトは、正確に動作するごく標準的な環境を構築するのを目的としています。
それ以上の環境が必要な場合は、出来た環境からさらに独自のカスタマイズを行うのがベターです。

## 対象OS
- CentOS 7, Ubuntu18

## ライセンス

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

# 実行内容
ローカルにAnsibleをインストールし、Ansible GalaxyのPlaybookを基本に少しカスタマイズして環境構築しています。
次の特色があります。

- 最新のソフトウェア環境
- 日本語最適化

# 使い方
新規にOSをインストールしたサーバに`root`でログインし、構築したい環境のスクリプトを実行します。
完了後は一旦サーバを再起動してください。

## Webサーバ(LEMP)環境構築 (所要時間: 約10分)
Linux(L),Nginx(N),MariaDB(M),PHP(P)のLEMP環境を作成します。

### バージョン
- Nginx 1.16.0(CentOS), Nginx 1.14.0(Ubuntu)
- PHP 7.3
- MariaDB 10.3.15

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp.sh | bash
```
## 動画配信サーバ(LEMP+FFmpeg)環境構築 (所要時間: 約1時間)
LEMP環境作成後、必要なライブラリを集めて最新のFFmpegのビルド処理を行います。FFmpegのビルドには時間がかかります。

Nginxは最新ソースにRTMPモジュールを追加してビルドしています。
FFmpegはコーデックにAV1やh265等に対応しています。その他のFFmpegの設定は[こちら](https://github.com/czbone/oneliner-env/blob/master/ffmpeg_spec.txt )を参照してください。

### バージョン
- Nginx 1.17.3
- PHP 7.3.8
- MariaDB 10.3.17
- FFmpeg 4.2

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp_ffmpeg.sh | bash
```

# 動作チェック

環境構築後、WebブラウザでURLにアクセスし、簡単に動作チェックを行います。「localhost」部分は環境に合わせて変更してください。

phpinfoが表示されます。
```
http://localhost/index.php
```

テスト用DBに日本語文字列を登録し再表示させます。文字化けせずに日本語が表示されていればOKです。
```
http://localhost/index2.php
```

# 検証環境
- **Vagrant Box** CentOS7「centos/7」, Ubuntu18「ubuntu/bionic64」
- **さくらVPS** 「CentOS7」(標準OS), 「Ubuntu18.04 amd64」(カスタムOS)
