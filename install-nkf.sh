#!/usr/bin/env bash
num=$(wget -q -O - 'https://jaist.dl.osdn.jp/nkf/?C=M;O=D' | grep -P -m1 -o '(?<=href=")[[:digit:]]+(?=/")')
nkfver=$(wget -q -O - 'https://jaist.dl.osdn.jp/nkf/'$num'?C=M;O=D' | grep -P -m1 -o '(?<=href=")nkf-[[:digit:].]+(?=\.tar\.gz")')

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $nkfver.tar.gz https://jaist.dl.osdn.jp/nkf/$num/$nkfver.tar.gz
rm -rf $nkfver
tar -xf $nkfver.tar.gz
cd $nkfver
make -j4
make install
