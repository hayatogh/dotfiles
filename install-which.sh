#!/usr/bin/env bash
with_sudo=1
. $(realpath $(dirname $0))/install-helper.sh

ver=$(wget -qO- http://carlowood.github.io/which/ | grep -Po '(?<=HREF="which-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=which-$ver
url=https://carlowood.github.io/which/$dir.tar.gz
exe=which
local_ver() {
	which --version | grep -Po '(?<=v)[0-9.]+'
}
install_func() {
	wget_tar_cd /usr/local/src
	./configure --prefix=/usr/local
	make -j4
	make install
}

helper
