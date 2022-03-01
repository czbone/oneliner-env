#!/bin/bash
# 
# Script Name: build_lemp.sh
#
# Version:      5.1.0
# Author:       Naoki Hirata
# Date:         2022-03-01
# Usage:        build_lemp.sh [-test]
# Options:      -test      test mode execution with the latest source package
# Description:  This script builds LEMP(Linux Nginx, MariaDB, Linux) server environment with the one-liner command.
# Version History:
#               1.0.0  (2018-12-09) initial version
#               1.1.0  (2018-12-12) fix PHP_SELF incorrect problem
#                                   fix PHP session not seved problem
#               1.2.0  (2018-12-12) update for PHP v7.3
#               2.0.0  (2019-01-06) support Ubuntu18
#               2.1.0  (2019-06-03) fix Ubuntu18 Ansible repository problem
#               3.1.0  (2021-09-02) add Git
#               4.0.0  (2022-02-07) support CentOS 8 and unsupport CentOS 7
#               4.0.1  (2022-02-26) fix ansible-galaxy command option
#               5.0.0  (2022-02-28) install ansible by epel-next-release repository
#               5.1.0  (2022-03-01) support CentOS Stream 9
# License:      MIT License

# Define macro parameter
readonly GITHUB_USER="czbone"
readonly GITHUB_REPO="oneliner-env"
readonly WORK_DIR=/root/${GITHUB_REPO}_work
readonly PLAYBOOK="lemp"
readonly LOCAL_ANSIBLE_BIN=/root/.local/bin
readonly INSTALL_PACKAGE_CMD="dnf -y install"

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
declare DIST_NAME=""

if [ "$(uname)" == 'Darwin' ]; then
    OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    RELEASE_FILE=/etc/os-release
    if grep '^NAME="CentOS' ${RELEASE_FILE} >/dev/null; then
        OS="CentOS"
        DIST_NAME="CentOS"

        OS_VERSION=$(. /etc/os-release; echo $VERSION_ID)
        if [ $((OS_VERSION)) -lt 8 ]; then
            echo "Unsupported os version. The minimum required version is 8."
            exit 1
        fi
    elif grep '^NAME="Rocky Linux' ${RELEASE_FILE} >/dev/null; then
        OS="CentOS"
        DIST_NAME="Rocky Linux"
    elif grep '^NAME="AlmaLinux' ${RELEASE_FILE} >/dev/null; then
        OS="CentOS"
        DIST_NAME="Alma Linux"
    elif grep '^NAME="Amazon' ${RELEASE_FILE} >/dev/null; then
        OS="Amazon Linux"
    elif grep '^NAME="Ubuntu' ${RELEASE_FILE} >/dev/null; then
        OS="Ubuntu"
    fi
elif [ "$(expr substr $(uname -s) 1 6)" == 'CYGWIN' ]; then
    OS='Cygwin'
fi

# Exit if unsupported os
if [ "${DIST_NAME}" == '' ]; then
    echo "Your platform is not supported."
    uname -a
    exit 1
fi

echo "########################################################################"
echo "# $DIST_NAME"
echo "# START BUILDING ENVIRONMENT"
echo "########################################################################"

# Get test mode
if [ "$1" == '-test' ]; then
    readonly TEST_MODE=true
    
    echo "################# START TEST MODE #################"
else
    readonly TEST_MODE=false
fi

# Install ansible command
if ! type -P ansible >/dev/null ; then
    if [ "${DIST_NAME}" == 'CentOS' ]; then
        ${INSTALL_PACKAGE_CMD} ansible-core
    elif [ "${DIST_NAME}" == 'Rocky Linux' ]; then
        ${INSTALL_PACKAGE_CMD} ansible-core
    # elif [ "${DIST_NAME}" == 'Alma Linux' ]; then
    fi
fi

# If ansible not installed, install ansible by local mode
if ! type -P ansible >/dev/null ; then
    # Install ansible with Python3.8
    ${INSTALL_PACKAGE_CMD} python38
    pip3.8 install --user ansible
    readonly ANSIBLE_LOCAL_MODE=true
else
    readonly ANSIBLE_LOCAL_MODE=false
fi

# Install git command
${INSTALL_PACKAGE_CMD} git

# Download the latest repository archive
if ${TEST_MODE}; then
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
if ${ANSIBLE_LOCAL_MODE}; then
    echo "################# START ANSIBLE LOCAL MODE #################"
    ${LOCAL_ANSIBLE_BIN}/ansible-galaxy install --role-file=requirements.yml
    ${LOCAL_ANSIBLE_BIN}/ansible-playbook -i localhost, main.yml
else
    ansible-galaxy install --role-file=requirements.yml
    ansible-playbook -i localhost, main.yml
fi
