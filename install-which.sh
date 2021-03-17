#!/usr/bin/env bash
if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit $?
fi

ver=$(wget -qO- 'http://carlowood.github.io/which/' | grep -Pom1 '(?<=HREF="which-)[0-9.]+(?=\.tar\.gz")')
dir=which-$ver
url=https://carlowood.github.io/which/$dir.tar.gz

msg=$(which --version |& grep -Po '(?<=v)[0-9.]+')
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
wget -qO $tmp $url
tar -xf $tmp
cd $dir
./configure --prefix=/usr/local
make -j4
make install
rm -f $tmp
