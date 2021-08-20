#!/usr/bin/env bash
with_sudo=1
. $(realpath $(dirname $0))/install-helper.sh

cd /usr/local/src
git_clone git://github.com/vim/vim
cd vim/src
./configure --prefix=/usr/local &>/dev/null
sed -i -E 's/install-languages|install-tool-languages//' auto/config.mk
make -j4 &>/dev/null
make install &>/dev/null
