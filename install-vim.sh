#!/usr/bin/env bash
if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit $?
fi

mkdir -p /usr/local/src
cd /usr/local/src
rm -rf vim
git clone --depth 1 -- git://github.com/vim/vim
cd vim/src
./configure --prefix=/usr/local
sed -i -E 's/install-languages|install-tool-languages//' auto/config.mk
make -j4
make install
