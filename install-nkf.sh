#!/usr/bin/env bash
num=$(wget -qO- 'https://jaist.dl.osdn.jp/nkf/?C=M;O=D' | grep -Pom1 '(?<=href=")[0-9]+(?=/")')
ver=$(wget -qO- 'https://jaist.dl.osdn.jp/nkf/'$num'?C=M;O=D' | grep -Pom1 '(?<=href="nkf-)[0-9.]+(?=\.tar\.gz")')
dir=nkf-$ver
url=https://jaist.dl.osdn.jp/nkf/$num/$dir.tar.gz

msg=$(nkf --version |& grep -Po '(?<= )[0-9.]+(?= )')
if [[ $? -ne 0 ]]; then
	msg="Not installed"
fi
echo "Installed:     $msg"
echo "Remote latest: $ver"

if [[ $1 == -n || $msg == $ver && $1 != -f ]]; then
	exit
fi

tmp=$(mktemp)
mkdir -p ~/.local/src
cd ~/.local/src
wget -qO $tmp $url
rm -rf $dir
tar -xf $tmp
cd $dir
make -j4
make prefix=~/.local install
rm -f $tmp
