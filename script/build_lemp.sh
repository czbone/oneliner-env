#!/bin/sh

declare OS="unsupported os"
if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  RELEASE_FILE=/etc/os-release
  if grep '^NAME="CentOS' "${RELEASE_FILE}" >/dev/null; then
   OS=CentOS
  elif grep '^NAME="Amazon' "${RELEASE_FILE}" >/dev/null; then
   OS="Amazon Linux"
  elif grep '^NAME="Ubuntu' "${RELEASE_FILE}" >/dev/null; then
   OS=Ubuntu
  else
    echo "Your platform is not supported."
    uname -a
    exit 1
  fi
elif [ "$(expr substr $(uname -s) 1 6)" == 'CYGWIN' ]; then
  OS='Cygwin'
else
  echo "Your platform is not supported."
  uname -a
  exit 1
fi

echo "Get OS is $OS"