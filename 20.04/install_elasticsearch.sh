#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "Please execute this script as ROOT user!"; exit 1; }

# set JAVA_HOME
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-11-openjdk-amd64/bin:/usr/lib/jvm/java-11-openjdk-amd64/db/bin:/usr/lib/jvm/java-11-openjdk-amd64/jre/bin"
export J2SDKDIR="/usr/lib/jvm/java-11-openjdk-amd64"
export J2REDIR="/usr/lib/jvm/java-11-openjdk-amd64/jre*"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export DERBY_HOME="/usr/lib/jvm/java-11-openjdk-amd64/db"

function install_java {
    sudo apt-get update
    apt-get install -y openjdk-11-jre
}

function install_es {
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
    sudo apt-get update
    sudo apt-get install -y elasticsearch
    sudo systemctl start elasticsearch
    sudo systemctl enable elasticsearch
}

call_function install_java "Installing JAVA" ${LOG_PATH}
call_function install_es "Installing Elasticsearch 7" ${LOG_PATH}

ansi --green --bold -n "elasticsearch installed successfully"
