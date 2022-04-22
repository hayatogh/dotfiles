#!/usr/bin/env bash
set -euo pipefail

rm -rf ~/.vim/pack/minpac/opt/minpac
git clone --depth 1 -- https://github.com/matsuhav/minpac.git ~/.vim/pack/minpac/opt/minpac &>/dev/null
vim -ENs -u ~/.vim/vimrc -i NONE '+MinLoad' '+q'
