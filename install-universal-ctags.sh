#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

mkdir -p /usr/local/src
cd /usr/local/src
rm -rf ctags
git clone --depth 1 -- https://github.com/universal-ctags/ctags &>/dev/null
cd ctags
./autogen.sh &>/dev/null
./configure --prefix=/usr/local &>/dev/null
make -j4 &>/dev/null
make install
