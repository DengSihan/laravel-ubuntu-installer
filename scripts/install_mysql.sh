#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh
source ${CURRENT_DIR}/../common/library.sh

mysql_root_password=$1

call_function "installing: mysql" install_mysql $mysql_root_password