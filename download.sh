#!/bin/bash

{ # this ensures the entire script is downloaded #

green="\e[1;32m"
nc="\e[0m"

echo -e "${green}===> downloading...${nc}"
cd $HOME
wget -q https://codeload.github.com/DengSihan/laravel-ubuntu-installer/legacy.tar.gz/main -O laravel-ubuntu-installer.tar.gz
rm -rf laravel-ubuntu-installer
tar zxf laravel-ubuntu-installer.tar.gz
mv laravel-ubuntu-installer-master laravel-ubuntu-installer
rm -f laravel-ubuntu-installer.tar.gz
echo -e "${green}===> downloaded${nc}"
echo ""
echo -e "${green}script is located at： ${HOME}/laravel-ubuntu-installer${nc}"

[ $(id -u) != "0" ] && {
    source ${HOME}/laravel-ubuntu-installer/common/ansi.sh
    ansi -n --bold --bg-yellow --black "Please execute this script as ROOT user! [ sudo su ]"
} || {
    bash ./laravel-ubuntu-installer/20.04/install.sh
}

cd - > /dev/null
} # this ensures the entire script is downloaded #
