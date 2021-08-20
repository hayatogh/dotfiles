#!/usr/bin/env bash
with_sudo=1
. $(realpath $(dirname $0))/install-helper.sh

ver=$(wget -qO- 'http://ftp.gnu.org/gnu/screen/?C=M;O=D' | grep -Po '(?<=href="screen-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=screen-$ver
url=http://ftp.gnu.org/gnu/screen/$dir.tar.gz
exe=screen
local_ver() {
	screen --version | grep -Po '(?<= )[0-9.]+(?= )' | sed -E 's/0([0-9])/\1/g'
}
install_func() {
	wget_tar_cd /usr/local/src
	./autogen.sh
	./configure --prefix=/usr/local --enable-colors256
	make -j4
	make install
	cp /usr/local/src/$dir/etc/etcscreenrc /usr/local/etc/screenrc
	cat /usr/local/src/$dir/terminfo/screencap >> /etc/termcap
}

helper
