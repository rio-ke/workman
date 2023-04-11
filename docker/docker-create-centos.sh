#!/bin/bash -ue

if [ $(whoami) != 'root' ]; then
  echo "ERR: You must be root to run this script"
  exit 1
fi

OS_VER=7

DISTRIB="centos"

TARGET_DIR="/var/tmp/${DISTRIB}${OS_VER}"


ARCH="${ARCH:-$(uname -m)}"

PACKAGES="bind-utils
centos-release-scl
centos-release-scl-rh
curl
epel-release
gcc
git
iproute
keyutils
make
net-tools
openssh-clients
openssh-server
tar
vim
wget
which
yum"


rpm -q yum-utils || yum install -y yum-utils

mkdir -p $TARGET_DIR
mkdir -p $TARGET_DIR/etc
mkdir -p "$TARGET_DIR/var/lib/rpm"

cp /etc/resolv.conf ${TARGET_DIR}/etc/

mkdir -p -m 755 "$TARGET_DIR"/dev
mknod -m 600 "$TARGET_DIR"/dev/console c 5 1
mknod -m 600 "$TARGET_DIR"/dev/initctl p
mknod -m 666 "$TARGET_DIR"/dev/full c 1 7
mknod -m 666 "$TARGET_DIR"/dev/null c 1 3
mknod -m 666 "$TARGET_DIR"/dev/ptmx c 5 2
mknod -m 666 "$TARGET_DIR"/dev/random c 1 8
mknod -m 666 "$TARGET_DIR"/dev/tty c 5 0
mknod -m 666 "$TARGET_DIR"/dev/tty0 c 4 0
mknod -m 666 "$TARGET_DIR"/dev/urandom c 1 9
mknod -m 666 "$TARGET_DIR"/dev/zero c 1 5

rpm --root "$TARGET_DIR" --initdb
