# Laravel-Ubuntu-Installer

![install-laravel-on-ubuntu](https://raw.githubusercontent.com/dengsihan/laravel-ubuntu-installer/main/logo.png)

Great thanks to [summerblue/laravel-ubuntu-init](https://github.com/summerblue/laravel-ubuntu-init), this script is based on it.

## Introduction
This script is for installing a [**Laravel**](https://laravel.com) environment on `Ubuntu 20.04`/`Ubuntu 18.04`/`Ubuntu 16.04`.

Please make sure you are running as `root`!

## Features
Default:
* Git
* PHP 7.4
* MySQL
* Nginx
* Composer
* Nodejs
* Redis

Optional:
* Elasticsearch 7

## Useage
```sh
wget -qO- https://raw.githubusercontent.com/dengsihan/laravel-ubuntu-installer/main/download.sh - | bash
```
if you want to use `php7.3`, please run
```sh
wget -qO- https://raw.githubusercontent.com/dengsihan/laravel-ubuntu-installer/php7.3/download.sh - | bash
```
install elasticsearch:
```sh
cd ~/laravel-ubuntu-installer
./20.04/install_elasticsearch.sh
```

## Daily Use
1. Add A New Site
```sh
./20.04/nginx_add_site.sh
```
2. Add A New MySQL user & database
```sh
./20.04/mysql_add_user.sh
```
3. Run script as `www-data`
```sh
sudowww 'php artisan config:cache'
```
