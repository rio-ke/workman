#!/bin/bash -ue

if [ $(whoami) != 'root' ]; then
  echo "ERR: You must be root to run this script"
  exit 1
fi

OS_VER=7

DISTRIB="centos"

TARGET_DIR="/var/tmp/${DISTRIB}${OS_VER}"
