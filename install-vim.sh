#!/bin/bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=~/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

mkdir -p $prefix/src
cd $prefix/src
rm -rf vim
git clone --depth 1 -- https://github.com/vim/vim &>/dev/null
cd vim/src
./configure --prefix=$prefix --disable-nls &>/dev/null
make -j$(nproc) &>/dev/null
make install &>/dev/null
