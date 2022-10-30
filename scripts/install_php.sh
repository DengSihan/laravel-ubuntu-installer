#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh
source ${CURRENT_DIR}/../common/library.sh

install_composer=$1
install_composer=${install_composer:-N}

ansi --bold -n "Please input the php version which you want to install"
ansi --italic --faint "example: "
ansi --italic --faint --underline "7.4"
printf "\t"
ansi --italic --faint --underline -n "8.1"
ansi --italic --faint -n "(default 8.1)"
read -p "" php_version
php_version=${php_version:-8.1}

call_function "installing: php $php_version" install_php $php_version

if [[ $install_composer = "Y" ]];
then
	call_function "installing: composer" install_composer
else
	ansi --bold "Do you want to install composer?"
	ansi --italic --faint -n "(y/n)"
	read -p "" need_install_composer
	need_install_composer=${need_install_composer:-y}

	if [[ $need_install_composer = "y" ]]; then
		call_function "installing: composer" install_composer
	fi
fi