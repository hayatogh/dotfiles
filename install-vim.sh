#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
# prefix=$HOME/.local

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

mkdir -p $prefix/src
cd $prefix/src
rm -rf vim
git clone --depth 1 -- https://github.com/vim/vim &>/dev/null
cd vim/src
./configure --prefix=$prefix &>/dev/null
sed -Ei 's/install-languages|install-tool-languages//' auto/config.mk
make -j4 &>/dev/null
make install &>/dev/null
