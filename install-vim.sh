#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

mkdir -p /usr/local/src
cd /usr/local/src
rm -rf vim
git clone --depth 1 -- https://github.com/vim/vim &>/dev/null
cd vim/src
./configure --prefix=/usr/local &>/dev/null
sed -Ei 's/install-languages|install-tool-languages//' auto/config.mk
make -j4 &>/dev/null
make install &>/dev/null
