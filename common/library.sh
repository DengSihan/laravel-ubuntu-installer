#!/bin/bash

COMMON_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )
source "${COMMON_DIR}"/ansi.sh

function check_if_is_installed {
	local software_name check_software_version_func

	software_name=$1; shift || return
	check_software_version_func="get_${software_name}_version"

	if "$@" > /dev/null 2> /dev/null; 
	then
		ansi -n --bold --bg-red " You had already installed $software_name $( $check_software_version_func ) "
		return 1
	else
		return 0
	fi
}

# init system
function init_alias {
    alias sudowww > /dev/null 2>&1 || {
        echo "alias sudowww='sudo -H -u ${WWW_USER} sh -c'" >> ~/.bash_aliases
    }
}
function init_system {
    export LC_ALL="en_US.UTF-8"
    echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
    locale-gen en_US.UTF-8

    apt-get update
    apt-get install -y software-properties-common acl

    init_alias
}

# git
function get_git_version {
	git --version | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_git {
	if check_if_is_installed git git --version; then
		apt-get install -y curl git
		ansi -n --bg-black --green-intense --italic "git $( get_git_version ) has installed successfully!"
	fi
}

# php
function get_php_version {
	php -version | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_php {
	if check_if_is_installed php php --version; then
		local version
		version=$1
		sudo add-apt-repository -y ppa:ondrej/php
		apt-get update
		apt-get install -y "php$version-bcmath" "php$version-cli" "php$version-curl" "php$version-fpm" "php$version-gd" "php$version-mbstring" "php$version-mysql" "php$version-opcache" "php$version-pgsql" "php$version-readline" "php$version-xml" "php$version-zip" "php$version-sqlite3" "php$version-redis" "php$version-gmp"
		ansi -n --bg-black --green-intense --italic "php $( get_php_version ) has installed successfully!"
	fi
}

# composer
function get_composer_version {
	sudo su -l www-data -s /bin/bash -c "cd $PWD; composer -V" | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_composer {
	if check_if_is_installed composer sudo su -l www-data -s /bin/bash -c "cd $PWD; composer -V"; then
		curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
	    chmod +x /usr/local/bin/composer
	    ansi -n --bg-black --green-intense --italic "composer $( get_composer_version ) has installed successfully!"
	fi
}

# mysql
function get_mysql_version {
	mysql -V | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_mysql {
	if check_if_is_installed mysql mysql -V; then
		local password
		password=$1
		debconf-set-selections <<< "mysql-server mysql-server/root_password password $password"
	    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $password"
	    apt-get install -y mysql-server
	    ansi -n --bg-black --green-intense --italic "mysql $( get_mysql_version ) has installed successfully!"
	fi
}

# nvm
function get_nvm_version {
	nvm --version | head -n1
}
function install_nvm {
	if check_if_is_installed nvm nvm --version; then
		# https://github.com/nvm-sh/nvm
	    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
	    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
		ansi -n --bg-black --green-intense --italic "nvm $( get_nvm_version ) has installed successfully!"
	fi
}

# node
function get_node_version {
	node --version | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_node {
	if check_if_is_installed node node --version; then
		local version
		version=$1
		nvm install "$version"
		nvm use node
		ansi -n --bg-black --green-intense --italic "node $( get_node_version ) has installed successfully!"
	fi
}

# yarn
function get_yarn_version {
	yarn --version | head -n1
}
function install_yarn {
	if check_if_is_installed yarn yarn --version; then
		npm install --global yarn
		ansi -n --bg-black --green-intense --italic "yarn $( get_yarn_version ) has installed successfully!"
	fi
}

# pm2
function get_pm2_version {
	pm2 --version | head -n1
}
function install_pm2 {
	if check_if_is_installed pm2 pm2 --version; then
		npm install pm2@latest -g
		ansi -n --bg-black --green-intense --italic "pm2 $( get_pm2_version ) has installed successfully!"
	fi

}

# redis
function get_redis_version {
	redis-server --version | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_redis {
	if check_if_is_installed redis redis-server --version; then
		apt-get install -y redis-server
		ansi -n --bg-black --green-intense --italic "redis-server $( get_redis_version ) has installed successfully!"
	fi
}

# nginx
function get_nginx_version {
	nginx -v | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_nginx {
	if check_if_is_installed nginx nginx -v; then
		apt-get remove -y apache2
		apt-get install -y nginx nginx-extras
		chown -R "${WWW_USER}"."${WWW_USER_GROUP}" /var/www/
	    systemctl enable nginx.service
	    ansi -n --bg-black --green-intense --italic "nginx $( get_nginx_version ) has installed successfully!"
	fi
}

# java
function get_java_version {
	java --version | grep -Po "(\d+\.)+\d+" | head -n1
}
function install_java {
	if check_if_is_installed java java --version; then
		sudo apt-get update
    	apt-get install -y openjdk-11-jre
	    ansi -n --bg-black --green-intense --italic "java $( get_java_version ) has installed successfully!"
	fi
}

# elasticsearch 7
function get_elasticsearch_version {
	curl -XGET 'http://localhost:9200' | grep -Po "(\d+\.)+\d" | head -n1
}
function check_if_elasticsearch_is_install {
	if curl -XGET 'http://localhost:9200' > /dev/null 2> /dev/null;
	then
		ansi -n --bold --bg-red " You had already installed elasticsearch $( get_elasticsearch_version ) "
		return 1
	else
		return 0
	fi
}
function install_elasticsearch {
	if check_if_is_installed java java --version; then
		install_java
	fi

	if check_if_elasticsearch_is_install; then
		wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
	    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
	    sudo apt-get update
	    sudo apt-get install -y elasticsearch
	    sudo systemctl start elasticsearch
	    sudo systemctl enable elasticsearch
	    ansi -n --bg-black --green-intense --italic "elasticsearch $( get_elasticsearch_version ) has installed successfully!"
	fi
}

# elasticsearch ik plugin
function get_elasticsearch_home_path {
	curl "localhost:9200/_nodes/settings?pretty=true" | grep -Po '"home" : .*?[^\\]"' | grep -Po '\/(.*?[^//])\/elasticsearch'
}
function check_if_elasticsearch_ik_is_install {
	local es_plugin_path

	es_plugin_path="$( get_elasticsearch_home_path )/bin/elasticsearch-plugin";
	
	if $es_plugin_path list | grep 'analysis-ik' > /dev/null 2> /dev/null;
	then
		ansi -n --bold --bg-red " You had already installed ik plugin "
		return 1
	else
		return 0
	fi
}
function install_elasticsearch_ik {
	local es_plugin_path

	if check_if_elasticsearch_ik_is_install; then
		es_plugin_path="$( get_elasticsearch_home_path )/bin/elasticsearch-plugin";

		$es_plugin_path install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.17.1/elasticsearch-analysis-ik-7.17.1.zip

		sudo systemctl restart elasticsearch.service
		curl http://127.0.0.1:9200/
	fi
}