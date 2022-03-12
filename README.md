# Laravel-Ubuntu-Installer

![install-laravel-on-ubuntu](https://raw.githubusercontent.com/dengsihan/laravel-ubuntu-installer/main/logo.png)

## Introduction
This script is for installing a [**Laravel**](https://laravel.com) environment on Ubuntu.

Please make sure you are running as `root`!

## Features

* js (nvm + node + npm + yarn + pm2)
* php (php + composer)
* mysql
* nginx
* redis
* elasticsearch (elasticsearch 7 + ik plugin)

You can choose stuffs you need to install instead of install all of them.

![install-laravel-on-ubuntu](https://raw.githubusercontent.com/dengsihan/laravel-ubuntu-installer/main/main.gif)

Also, you can install any version of node / php by inputting the version of them.

## Useage
```sh
wget -qO- https://raw.githubusercontent.com/dengsihan/laravel-ubuntu-installer/main/download.sh - | bash
```

## Daily Use
1. Add A New Site
```sh
./scripts/nginx_add_site.sh
```
2. Add A New MySQL user & database
```sh
./scripts/mysql_add_user.sh
```
3. Run script as `www-data`
```sh
sudowww 'php artisan config:cache'
```
