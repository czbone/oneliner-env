# 1行打ち環境構築
サーバにrootログインし１行のコマンドを実行するだけで環境構築できるスクリプトです。
環境構築は難しい、時間がかかるという問題を解決します。

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
