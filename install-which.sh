#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit
fi

ver=$(wget -qO- http://carlowood.github.io/which/ | grep -Po '(?<=HREF="which-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=which-$ver
url=https://carlowood.github.io/which/$dir.tar.gz

loc="Not installed"
if which --version &>/dev/null; then
	loc=$(which --version | grep -Po '(?<=v)[0-9.]+' || true)
fi
echo "Installed:     $loc"
echo "Remote latest: $ver"

arg=${1:-}
if [[ $arg == -n || $loc == $ver && $arg != -f ]]; then
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
