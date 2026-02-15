#!/bin/bash
set -euo pipefail

prefix=~/.local
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
