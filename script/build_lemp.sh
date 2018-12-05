#!/bin/bash

# Check os version
declare OS="unsupported os"

if [ "$(uname)" == 'Darwin' ]; then
    OS='Mac'
    uname -a
    exit 1
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    RELEASE_FILE=/etc/os-release
    if grep '^NAME="CentOS' "${RELEASE_FILE}" >/dev/null; then
        OS="CentOS"
    elif grep '^NAME="Amazon' "${RELEASE_FILE}" >/dev/null; then
        OS="Amazon Linux"
        uname -a
        exit 1
    elif grep '^NAME="Ubuntu' "${RELEASE_FILE}" >/dev/null; then
        OS="Ubuntu"
    else
        echo "Your platform is not supported."
        uname -a
        exit 1
    fi
elif [ "$(expr substr $(uname -s) 1 6)" == 'CYGWIN' ]; then
    OS='Cygwin'
    uname -a
    exit 1
else
    echo "Your platform is not supported."
    uname -a
    exit 1
fi

echo "Get OS is $OS"
echo "########################################################################"
echo "# START BUILDING ENVIRONMENT"
echo "########################################################################"
if [ $OS == 'CentOS' ]; then
    INSTALL_PACKAGE_CMD="yum -y install"
elif [ $OS == 'Ubuntu' ]; then
    INSTALL_PACKAGE_CMD="apt-get install"
fi
$INSTALL_PACKAGE_CMD git
$INSTALL_PACKAGE_CMD ansible

