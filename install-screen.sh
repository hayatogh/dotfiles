#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

ver=$(wget -qO- 'http://ftp.gnu.org/gnu/screen/?C=M;O=D' | grep -Po '(?<=href="screen-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=screen-$ver
url=http://ftp.gnu.org/gnu/screen/$dir.tar.gz

echo "Installed:     $(screen --version 2>/dev/null | grep -Po '(?<= )[0-9.]+(?= )' | sed -E 's/0([0-9])/\1/g' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p /usr/local/src
cd /usr/local/src
wget -qO $dir.tar.gz $url
rm -rf $dir
tar -xf $dir.tar.gz
cd $dir
./autogen.sh &>/dev/null
./configure --prefix=/usr/local --enable-colors256 &>/dev/null
make -j4 &>/dev/null
make install &>/dev/null
cp /usr/local/src/$dir/etc/etcscreenrc /usr/local/etc/screenrc
cat /usr/local/src/$dir/terminfo/screencap >>/etc/termcap
