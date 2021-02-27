#!/usr/bin/env bash
rm -rf ~/.vim/pack/minpac/opt/minpac
git clone --depth 1 -- git://github.com/matsuhav/minpac.git ~/.vim/pack/minpac/opt/minpac &>/dev/null
vim -ENs -u ~/.vim/vimrc -i NONE '+MinLoad' '+q'
