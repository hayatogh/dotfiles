#!/usr/bin/env bash
set -euo pipefail

num=$(wget -qO- 'https://jaist.dl.osdn.jp/nkf/?C=M;O=D' | grep -Po '(?<=href=")[0-9]+(?=/")' | head -n1)
ver=$(wget -qO- 'https://jaist.dl.osdn.jp/nkf/'$num'?C=M;O=D' | grep -Po '(?<=href="nkf-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=nkf-$ver
url=https://jaist.dl.osdn.jp/nkf/$num/$dir.tar.gz

loc=$(nkf --version |& grep -Po '(?<= )[0-9.]+(?= )' || true)
if [[ -z $loc ]]; then
	loc="Not installed"
fi
echo "Installed:     $loc"
echo "Remote latest: $ver"

arg=${1:-""}
if [[ $arg == -n || $loc == $ver && $arg != -f ]]; then
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
