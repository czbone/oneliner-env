#!/bin/bash
# 
# Script Name: build_lemp.sh
#
# Version:      2.0.0
# Author:       Naoki Hirata
# Date:         2019-01-06
# Usage:        build_lemp.sh [-test]
# Options:      -test      test mode execution with the latest source package
# Description:  This script builds LEMP(Linux Nginx, MariaDB, Linux) server environment with the one-liner command.
# Version History:
#               1.0.0  (2018-12-09) initial version
#               1.1.0  (2018-12-12) fix PHP_SELF incorrect problem
#                                   fix PHP session not seved problem
#               1.2.0  (2018-12-12) update for PHP v7.3
#               2.0.0  (2019-01-06) support Ubuntu18
# License:      MIT License

# Define macro parameter
readonly GITHUB_USER="czbone"
readonly GITHUB_REPO="oneliner-env"
readonly WORK_DIR=/root/${GITHUB_REPO}_work
readonly PLAYBOOK="lemp"

# check root user
readonly USERID=`id | sed 's/uid=\([0-9]*\)(.*/\1/'`
echo $USERID;
if [ $USERID -ne 0 ]
then
    echo "error: can only excute by root"
    exit 1
fi

# Check os version
declare OS="unsupported os"

if [ "$(uname)" == 'Darwin' ]; then
    OS='Mac'
    uname -a
    exit 1
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    RELEASE_FILE=/etc/os-release
    if grep '^NAME="CentOS' ${RELEASE_FILE} >/dev/null; then
        OS="CentOS"
    elif grep '^NAME="Amazon' ${RELEASE_FILE} >/dev/null; then
        OS="Amazon Linux"
        uname -a
        exit 1
    elif grep '^NAME="Ubuntu' ${RELEASE_FILE} >/dev/null; then
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

echo "########################################################################"
echo "# $OS LEMP                                                             #"
echo "# START BUILDING ENVIRONMENT                                           #"
echo "########################################################################"
echo "Param={$1}"
# Get test mode
if [[  "$1" = '-test'  ]]; then
    readonly TEST_MODE="true"
    
    echo "################# START TEST MODE #################"
else
    readonly TEST_MODE="false"
fi

declare INSTALL_PACKAGE_CMD=""
if [ $OS == 'CentOS' ]; then
    INSTALL_PACKAGE_CMD="yum -y install"
elif [ $OS == 'Ubuntu' ]; then
    INSTALL_PACKAGE_CMD="apt -y install"
fi

$INSTALL_PACKAGE_CMD ansible

# Download the latest repository archive
if [ $TEST_MODE == 'true' ]; then
    url="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/master.tar.gz"
    version="new"
else
    url=`curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/tags" | grep "tarball_url" | \
        sed -n '/[ \t]*"tarball_url"/p' | head -n 1 | \
        sed -e 's/[ \t]*".*":[ \t]*"\(.*\)".*/\1/'`
    version=`basename $url | sed -e 's/v\([0-9\.]*\)/\1/'`
fi
filename=${GITHUB_REPO}_${version}.tar.gz
filepath=${WORK_DIR}/$filename

# Set current directory
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}
savefilelist=`ls -1`

# Download archived repository
echo "########################################################################"
echo "Start download GitHub repository ${GITHUB_USER}/${GITHUB_REPO}" 
curl -s -o ${filepath} -L $url

# Remove old files
for file in $savefilelist; do
    if [ ${file} != ${filename} ]
    then
        rm -rf "${file}"
    fi
done

# Get archive directory name
destdir=`tar tzf ${filepath} | head -n 1`
destdirname=`basename $destdir`

# Unarchive repository
tar xzf ${filename}
find ./ -type f -name ".gitkeep" -delete
mv ${destdirname} ${GITHUB_REPO}
echo ${filename}" unarchived"

# launch ansible
cd ${WORK_DIR}/${GITHUB_REPO}/playbooks/${PLAYBOOK}
ansible-galaxy install --role-file=requirements.yml --roles-path=/etc/ansible/roles --force
ansible-playbook -i localhost, main.yml
