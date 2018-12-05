# 1行打ち環境構築
サーバにrootログインし１行のコマンドを実行するだけで環境構築できるスクリプトです。
必要なソフトウェアがすべて1台のサーバに納まるようにパッケージ化された環境を作ります。
環境構築は難しい、たいへん時間がかかるという問題を即時解決します。

## 注意
このプロジェクトは、正確に動作するごく標準的な環境を構築するのを目的としています。
それ以上の環境が必要な場合は、出来た環境からさらに独自のカスタマイズを行うのがベターです。

# 対象OS
- CentOS 7
- Ubuntu 14

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## 実行内容
ローカルにAnsibleをインストールし、Ansible GalaxyのPlaybookを基本に少しカスタマイズして環境構築しています。
次の特色があります。

- 最新のソフトウェア環境
- 日本語対応

# テスト中
## LEMP環境構築(CentOS 7)
Linux(L),Nginx(N),MariaDB(M),PHP(P)のLEMP環境を作成します。
PHPはバージョン7.0以上です。

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp_centos7.sh | sh
```
