#!/usr/bin/env bash
if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit $?
fi

ver=$(wget -qO- 'http://ftp.gnu.org/gnu/screen/?C=M;O=D' | grep -Pom1 '(?<=href="screen-)[0-9.]+(?=\.tar\.gz")')
dir=screen-$ver
url=http://ftp.gnu.org/gnu/screen/$dir.tar.gz

msg=$(screen --version |& grep -Po '(?<= )[0-9.]+(?= )')
if [[ $? -ne 0 ]]; then
	msg="Not installed"
fi
echo "Installed:     $msg"
echo "Remote latest: $ver"

if [[ $1 == -n || $msg == $ver && $1 != -f ]]; then
	exit
fi

tmp=$(mktemp)
mkdir -p /usr/local/src
cd /usr/local/src
rm -rf $dir
wget -qO $tmp $url
tar -xf $tmp
cd $dir
./autogen.sh
./configure --prefix=/usr/local --enable-colors256
make -j4
make install
cp /usr/local/src/$dir/etc/etcscreenrc /usr/local/etc/screenrc
cat /usr/local/src/$dir/terminfo/screencap >> /etc/termcap
rm -f $tmp
