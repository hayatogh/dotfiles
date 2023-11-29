#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=$HOME/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

ver=$(curl -fsS 'https://ftp.gnu.org/pub/gnu/global/?C=M;O=D' | grep -Po '(?<=href="global-)[0-9.]+(?=\.tar\.gz")' | head -n1)
dir=global-$ver
url=https://ftp.gnu.org/gnu/global/$dir.tar.gz

echo "Installed:     $(global --version 2>/dev/null | head -n1 | grep -Po '(?<= )[0-9.]+$' || echo "Not installed")"
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
./configure --prefix=$prefix &>/dev/null
make -j4 &>/dev/null
make install &>/dev/null
