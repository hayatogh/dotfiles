#!/usr/bin/env bash
. install-helper.sh

cd ~/.local/src
git_clone git://github.com/universal-ctags/ctags
cd ctags
./autogen.sh
./configure --prefix=~/.local
make -j4
make install
