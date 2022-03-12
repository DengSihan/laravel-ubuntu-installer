#!/bin/bash

COMMON_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${COMMON_DIR}/ansi.sh

export LOG_PATH=/var/log/laravel-ubuntu-init.log
export WWW_USER="www-data"
export WWW_USER_GROUP="www-data"

function call_function {
    local desc
    desc=$1; shift || return
    echo -n "===> ${desc}..."
    printf "\n"
    "$@"
}

random_string(){
    length=${1:-32}
    echo `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${length} | head -n 1`
}
