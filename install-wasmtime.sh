#!/bin/bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=~/.local
fi

if [[ ${1:-} != -n && $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

arch=$(uname -m)
dir=wasmtime-dev-$arch-linux
fname=$dir.tar.xz
url=https://github.com/bytecodealliance/wasmtime/releases/download/dev/$fname

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLo $fname $url
tar -xf $fname
mkdir -p $prefix/bin
cp $dir/wasmtime $prefix/bin/wasmtime
