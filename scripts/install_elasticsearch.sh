#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh
source ${CURRENT_DIR}/../common/library.sh

call_function "installing: elasticsearch 7" install_elasticsearch

install_ik=$1
install_ik=${install_ik:-N}

if [[ $install_ik = "Y" ]];
then
	call_function "installing: ik plugin" install_elasticsearch_ik
else
	ansi --bold "Do you want to install ik plugin for elasticsearch?"
	ansi --italic --faint -n "(y/n)"
	read -p "" need_install_elasticsearch_ik
	need_install_elasticsearch_ik=${need_install_elasticsearch_ik:-y}

	if [[ $need_install_elasticsearch_ik = "y" ]]; then
		call_function "installing: ik plugin" install_elasticsearch_ik
	fi
fi