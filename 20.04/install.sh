#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "Please execute this script as ROOT user!"; exit 1; }

MYSQL_ROOT_PASSWORD=`random_string`

function init_system {
    export LC_ALL="en_US.UTF-8"
    echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
    locale-gen en_US.UTF-8

    apt-get update
    apt-get install -y software-properties-common

    init_alias
}

function init_alias {
    alias sudowww > /dev/null 2>&1 || {
        echo "alias sudowww='sudo -H -u ${WWW_USER} sh -c'" >> ~/.bash_aliases
    }
}

function install_basic_softwares {
    apt-get install -y curl git build-essential unzip supervisor acl
}

function install_node_npm {
    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

function install_php {
    apt-get install -y php7.4-bcmath php7.4-cli php7.4-curl php7.4-fpm php7.4-gd php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-pgsql php7.4-readline php7.4-xml php7.4-zip php7.4-sqlite3 php7.4-redis
}

function install_others {
    apt-get remove -y apache2
    debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}"
    apt-get install -y nginx nginx-extras mysql-server redis-server
    chown -R ${WWW_USER}.${WWW_USER_GROUP} /var/www/
    systemctl enable nginx.service
}

function install_composer {
    curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
    chmod +x /usr/local/bin/composer
    # sudo -H -u ${WWW_USER} sh -c  'cd ~ && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/'
}

function install_plugins {
    npm install pm2@latest -g
    sudo apt-get install -y php7.4-gmp
    sudo apt-get install -y dos2unix
}

call_function init_system "System Initializing" ${LOG_PATH}
call_function install_basic_softwares "Installing git / build-essential / unzip / supervisor / acl" ${LOG_PATH}
call_function install_php "Installing PHP" ${LOG_PATH}
call_function install_node_npm "Installing Nodejs / npm" ${LOG_PATH}
call_function install_others "Installing Mysql / Nginx / Redis" ${LOG_PATH}
call_function install_composer "Installing Composer" ${LOG_PATH}
call_function install_plugins "Installing pm2 / php7.4-gmp / dos2unix" ${LOG_PATH}

ansi --green --bold -n "Installed Successfully"
ansi --green --bold "Mysql root password："; ansi -n --bold --bg-yellow --black ${MYSQL_ROOT_PASSWORD}
ansi --green --bold -n "Please execute [ source ~/.bash_aliases ] manully to make [ alias ] work"
