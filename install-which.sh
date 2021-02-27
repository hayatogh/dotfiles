#!/usr/bin/env bash
whichver=$(wget -q -O - 'http://carlowood.github.io/which/' | grep -P -m1 -o '(?<=HREF=")which-[[:digit:].]+(?=\.tar\.gz")')

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $whichver.tar.gz https://carlowood.github.io/which/$whichver.tar.gz
rm -rf $whichver
tar -xf $whichver.tar.gz
cd $whichver
./configure --prefix=/usr/local
make -j4
make install
