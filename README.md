概要
====================
Vagrantを使って仮想マシンにRedmineをセットアップ

## 必要環境
以下がインストール済みであること。
* Vagrant 1.1.x http://downloads.vagrantup.com/
* VirtualBox 4.2.x https://www.virtualbox.org/wiki/Downloads

## 実行方法
vagrant-up.bat (or vagrant-up.sh) を実行すると仮想マシンを起動する。
初回起動時にセットアップが自動実行。

仮想マシンを停止するには vagrant-halt.bat (or vagrant-halt.sh) を実行する。

## セットアップされる環境
* Ubuntu 12.04
* MySQL
* Ruby 1.9.3
* Redmine 2.3
* unicorn
* nginx

## TODO
* chefのcookbook
** cookbook、recipe分割
** パラメータ化
** 再実行不要の判定を入れる
* メール送信設定
