#!/usr/bin/env bash
. ~/dotfiles/install-helper.sh

num=$(wget -qO- 'https://jaist.dl.osdn.jp/nkf/?C=M;O=D' | grep -Po '(?<=href=")[0-9]+(?=/")' | head -n1)
ver=$(wget -qO- 'https://jaist.dl.osdn.jp/nkf/'$num'?C=M;O=D' | grep -Po '(?<=href="nkf-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=nkf-$ver
url=https://jaist.dl.osdn.jp/nkf/$num/$dir.tar.gz
exe=nkf
local_ver() {
	nkf --version | grep -Po '(?<= )[0-9.]+(?= )'
}
install_func() {
	wget_tar_cd ~/.local/src
	make -j4
	make prefix=~/.local install
}

helper
