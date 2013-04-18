概要
====================
Vagrantを使って仮想マシンにRedmineをセットアップ

## 必要環境
以下がインストール済みであること。
* Vagrant 1.1.x http://downloads.vagrantup.com/
* VirtualBox 4.2.x https://www.virtualbox.org/wiki/Downloads

## 実行方法
setup.bat (or setup.sh) を実行すると仮想マシンを起動してください。
初回起動時にセットアップが自動実行します。

セットアップ完了後の起動/停止はvagrantのコマンドかVirtualBoxからできます。

## セットアップされる環境
* Ubuntu 12.04
* MySQL
* Ruby 1.9.3
* Redmine 2.3
* unicorn
* nginx

## TODO
* cookbook、recipe分割
* recipe パラメータ化
* メール送信設定
