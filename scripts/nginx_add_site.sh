#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "Please execute this script as ROOT user!"; exit 1; }

read -r -p "project name：" project

read -r -p "domains (separated by spaces)：" domains

project_dir="/var/www/${project}"

ansi -n --bold --green "domains list：${domains}"
ansi -n --bold --green "project name：${project}"
ansi -n --bold --green "project dir：${project_dir}"

read -r -p "sure to create？ [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        ansi -n --bold --bg-red "cancel by user"
        exit 1
        ;;
esac

cat ${CURRENT_DIR}/nginx_site_conf.tpl |
    sed "s|{{domains}}|${domains}|g" |
    sed "s|{{project}}|${project}|g" |
    sed "s|{{project_dir}}|${project_dir}|g" > /etc/nginx/sites-available/${project}.conf

ln -sf /etc/nginx/sites-available/${project}.conf /etc/nginx/sites-enabled/${project}.conf

ansi -n --bold --green "nginx conf add successfully";

mkdir -p ${project_dir} && chown -R ${WWW_USER}.${WWW_USER_GROUP} ${project_dir}

systemctl restart nginx.service

ansi -n --bold --green "nginx restarted successfully";
