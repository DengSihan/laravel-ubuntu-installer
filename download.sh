#!/bin/bash

{ # this ensures the entire script is downloaded #

green="\e[1;32m"
nc="\e[0m"

echo -e "${green}===> Start Download${nc}"
cd $HOME
wget -q https://github.com/dengsihan/laravel-ubuntu-installer/archive/main.tar.gz -O laravel-ubuntu-installer.tar.gz
rm -rf laravel-ubuntu-installer
tar zxf laravel-ubuntu-installer.tar.gz
mv laravel-ubuntu-installer-main laravel-ubuntu-installer
rm -f laravel-ubuntu-installer.tar.gz
echo -e "${green}===> Download completed${nc}"
echo ""
echo -e "${green}script is located at： ${HOME}/laravel-ubuntu-installer${nc}"

source ${HOME}/laravel-ubuntu-installer/common/ansi.sh

[ $(id -u) != "0" ] && {
    ansi -n --bold --bg-red --white "Please execute this script as ROOT user! [ sudo su ]"
} || {
    chmod -R +x ./laravel-ubuntu-installer/
    ansi --bold --bg-black --green-intense "scripts is ready, please run: "
    ansi --bg-black --green-intense --italic --underline -n "${HOME}/laravel-ubuntu-installer/scripts/install.sh"
    printf "\n\n"
}

cd - > /dev/null
} # this ensures the entire script is downloaded #
