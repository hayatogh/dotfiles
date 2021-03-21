#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/.local/src
cd ~/.local/src
rm -rf ctags
git clone --depth 1 -- git://github.com/universal-ctags/ctags
cd ctags
./autogen.sh
./configure --prefix=~/.local
make -j4
make install
