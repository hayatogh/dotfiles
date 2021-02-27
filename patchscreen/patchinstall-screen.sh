#!/usr/bin/env bash
patchscreen=$(realpath $(dirname ${BASH_SOURCE[0]}))
screenver=$(wget -q -O - 'http://ftp.gnu.org/gnu/screen/?C=M;O=D' | grep -P -m1 -o '(?<=href=")screen-[[:digit:].]+(?=\.tar\.gz")')

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $screenver.tar.gz https://git.savannah.gnu.org/cgit/screen.git/snapshot/$screenver.tar.gz
rm -rf $screenver
tar -xf $screenver.tar.gz
cd $screenver/src
patch -i $patchscreen/disable-utmp.patch
patch -i $patchscreen/no-check-dirs-permission.patch
./autogen.sh
./configure --prefix=/usr/local --enable-colors256 --disable-pam
make -j4
make install
cp /usr/local/src/$screenver/src/etc/etcscreenrc /usr/local/etc/screenrc
cat /usr/local/src/$screenver/src/terminfo/screencap >> /etc/termcap
