#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh
source ${CURRENT_DIR}/../common/library.sh

install_all_js=$1
node_version=$2

install_all_js=${install_all_js:-N}
node_version=${node_version:-node}

call_function "installing: nvm" install_nvm

if [[ $install_all_js = "Y" ]];
then
	call_function "installing: node" install_node $node_version
	call_function "installing: yarn" install_yarn
	call_function "installing: pm2" install_pm2
else
	ansi --bold -n "Please input the node version which you want to install"
	ansi --italic --faint "example: "
	ansi --italic --faint --underline "14.7.0"
	printf "\t"
	ansi --italic --faint --underline -n "12.13.0"
	ansi --italic --faint -n "(default the latest version)"
	read -p "" node_version
	node_version=${node_version:-node}

	call_function "installing: node" install_node $node_version

	ansi --bold "Do you want to install yarn?"
	ansi --italic --faint -n "(y/n)"
	read -p "" need_install_yarn
	need_install_yarn=${need_install_yarn:-y}

	if [[ $need_install_yarn = "y" ]]; then
		call_function "installing: yarn" install_yarn
	fi

	ansi --bold "Do you want to install pm2?"
	ansi --italic --faint -n "(y/n)"
	read -p "" need_install_pm2
	need_install_pm2=${need_install_pm2:-y}

	if [[ $need_install_pm2 = "y" ]]; then
		call_function "installing: pm2" install_pm2
	fi
fi