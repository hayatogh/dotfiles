#!/usr/bin/env bash
mkdir -p /usr/local/src
cd /usr/local/src
rm -rf ctags
git clone --depth 1 -- git://github.com/universal-ctags/ctags
cd ctags
./autogen.sh
./configure --prefix=/usr/local
make -j4
make install
