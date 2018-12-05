#!/bin/bash

# Define macro parameter
readonly GITHUB_USER="czbone"
readonly GITHUB_REPO="oneliner-env"
readonly WORK_DIR=/root/${GITHUB_REPO}_work

# check root user
readonly USERID=`id | sed 's/uid=\([0-9]*\)(.*/\1/'`
if [ $USERID -ne 0 ]
then
    echo "error: only excute by root"
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
echo "# $OS LEMP                                                             #"
echo "# START BUILDING ENVIRONMENT                                           #"
echo "########################################################################"

declare INSTALL_PACKAGE_CMD=""
if [ $OS == 'CentOS' ]; then
    INSTALL_PACKAGE_CMD="yum -y install"
elif [ $OS == 'Ubuntu' ]; then
    INSTALL_PACKAGE_CMD="apt-get install"
fi
#$INSTALL_PACKAGE_CMD git
$INSTALL_PACKAGE_CMD ansible

# Download the latest repository archive
url=`curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/tags" | grep "tarball_url" | \
    sed -n '/[ \t]*"tarball_url"/p' | head -n 1 | \
    sed -e 's/[ \t]*".*":[ \t]*"\(.*\)".*/\1/'`
version=`basename $url | sed -e 's/v\([0-9\.]*\)/\1/'`
filename=${GITHUB_REPO}_${version}.tar.gz

# Set current directory
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}
savefilelist=`ls -1`

# Download archived repository
echo "Start download repository"
curl -s -o ${WORK_DIR}/$filename -L $url
echo "Download repository completed"
filepath=${WORK_DIR}/$filename
echo ${filepath}

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
