#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=$HOME/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

mkdir -p $prefix/src
cd $prefix/src
rm -rf ctags
git clone --depth 1 -- https://github.com/universal-ctags/ctags &>/dev/null
cd ctags
./autogen.sh &>/dev/null
./configure --prefix=$prefix &>/dev/null
make -j4 &>/dev/null
make install
