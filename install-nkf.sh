#!/usr/bin/env bash
num=$(wget -q -O - 'https://jaist.dl.osdn.jp/nkf/?C=M;O=D' | grep -Pom1 '(?<=href=")[0-9]+(?=/")')
nkfver=$(wget -q -O - 'https://jaist.dl.osdn.jp/nkf/'$num'?C=M;O=D' | grep -Pom1 '(?<=href=")nkf-[0-9.]+(?=\.tar\.gz")')

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $nkfver.tar.gz https://jaist.dl.osdn.jp/nkf/$num/$nkfver.tar.gz
rm -rf $nkfver
tar -xf $nkfver.tar.gz
cd $nkfver
make -j4
make install
