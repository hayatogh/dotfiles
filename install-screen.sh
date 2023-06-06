#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
# prefix=$HOME/.local

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

ver=$(curl -fsS 'https://ftp.gnu.org/gnu/screen/?C=M;O=D' | grep -Po '(?<=href="screen-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=screen-$ver
url=https://ftp.gnu.org/gnu/screen/$dir.tar.gz

echo "Installed:     $(screen --version 2>/dev/null | grep -Po '(?<= )[0-9.]+(?= )' | sed -E 's/0([0-9])/\1/g' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p $prefix/src
cd $prefix/src
curl -fsSo $dir.tar.gz $url
rm -rf $dir
tar -xf $dir.tar.gz
cd $dir
./autogen.sh &>/dev/null
./configure --prefix=$prefix --enable-colors256 &>/dev/null
make -j4 &>/dev/null
make install &>/dev/null
mkdir -p ../../etc
cp etc/etcscreenrc ../../etc/screenrc
if [[ $EUID == 0 ]]; then
	cat terminfo/screencap >>/etc/termcap
else
	cat terminfo/screencap >>../../etc/termcap
fi
