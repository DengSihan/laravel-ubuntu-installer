#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh
source ${CURRENT_DIR}/../common/ansi.sh
source ${CURRENT_DIR}/../common/select.sh
source ${CURRENT_DIR}/../common/library.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "Please execute this script as ROOT user!"; exit 1; }

call_function 'initing system' init_system

random_root_password=`random_string`

OPTIONS_VALUES=("js" "php" "mysql" "nginx" "redis" "elasticsearch")
OPTIONS_LABELS=("(nvm + node + npm + yarn + pm2)" "(php + composer)" "" "" "" "(elasticsearch 7 + ik plugin)")

for i in "${!OPTIONS_VALUES[@]}"; do
	OPTIONS_STRING+="${OPTIONS_VALUES[$i]} ${OPTIONS_LABELS[$i]};"
done

printf "\nIf you don't want to install all stuffs inside the brackets,\nfor example, you want to install php without composer,\nplease choose false and run the sub script "
ansi --bold --bg-black --italic "./scripts/install_php.sh"
printf " later.\n"
printf "Also, you can run the sub scripts to install the specific stuff.\n"

printf "\njs            => "
ansi --bold --bg-black --italic "./scripts/install_js.sh"
printf "\nphp           => "
ansi --bold --bg-black --italic "./scripts/install_php.sh"
printf "\nmysql         => "
ansi --bold --bg-black --italic "./scripts/install_mysql.sh"
printf "\nnginx         => "
ansi --bold --bg-black --italic "./scripts/install_nginx.sh"
printf "\nredis         => "
ansi --bold --bg-black --italic "./scripts/install_redis.sh"
printf "\nelasticsearch => "
ansi --bold --bg-black --italic "./scripts/install_elasticsearch.sh"
printf "\n\n"

prompt_for_multiselect SELECTED "$OPTIONS_STRING"

for i in "${!SELECTED[@]}"; do
	if [ "${SELECTED[$i]}" == "true" ]; then
		CHECKED+=("${OPTIONS_VALUES[$i]}")
	fi
done

stuffs="${CHECKED[@]}"

# git
if check_if_is_installed git git --version; then
	install_git
fi

# js
if echo $stuffs | grep "js" > /dev/null; then
	bash ${CURRENT_DIR}/install_js.sh Y
fi

# php
if echo $stuffs | grep "php" > /dev/null; then
	bash ${CURRENT_DIR}/install_php.sh Y
fi

# mysql
if echo $stuffs | grep "mysql" > /dev/null; then
	ansi --bold -n "Please input the password of mysql root user"
	ansi --italic --faint "default (random string): "
	ansi --italic --faint --bg-yellow-intense --black --underline -n "$random_root_password"
	read -p "" mysql_root_password
	mysql_root_password=${mysql_root_password:-$random_root_password}
	
	bash ${CURRENT_DIR}/install_mysql.sh $mysql_root_password
fi

# nginx
if echo $stuffs | grep "nginx" > /dev/null; then
	bash ${CURRENT_DIR}/install_nginx.sh
fi

# redis
if echo $stuffs | grep "redis" > /dev/null; then
	bash ${CURRENT_DIR}/install_redis.sh
fi

# elasticsearch
if echo $stuffs | grep "elasticsearch" > /dev/null; then
	bash ${CURRENT_DIR}/install_elasticsearch.sh Y
fi

printf "\n\n"
ansi -n --bg-black --green-intense --italic "$stuffs had been installed!"

if echo $stuffs | grep "mysql" > /dev/null; then
	printf "\n\n"
	ansi --bold --bg-black --green-intense -n "add mysql user: "
	ansi --bg-black --green-intense --italic --underline -n "${HOME}/installer/scripts/add_mysql_user.sh"
fi

if echo $stuffs | grep "nginx" > /dev/null; then
	printf "\n\n"
	ansi --bold --bg-black --green-intense -n "add nginx site: "
	ansi --bg-black --green-intense --italic --underline -n "${HOME}/installer/scripts/nginx_add_site.sh"
fi

printf "\n\n"
