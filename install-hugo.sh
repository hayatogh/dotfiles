#!/bin/bash
set -euo pipefail

prefix=~/.local
case $(uname -m) in
x86_64) arch=amd64;;
aarch64) arch=arm64;;
*) echo 'Unknown arch.'; exit 1;;
esac
ver=$(curl -fsSL https://api.github.com/repos/gohugoio/hugo/releases/latest | grep -Po '(?<="tag_name": "v)[0-9.]+(?=",)' | head -n1)
dir=hugo_extended_${ver}_linux-$arch
fname=$dir.tar.gz
url=https://github.com/gohugoio/hugo/releases/download/v$ver/$fname

echo Hugo
echo "Installed:     $(hugo version 2>/dev/null | grep -Po '(?<=v)[0-9.]+' || echo 'Not installed')"
echo "Remote latest: $ver"

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLO $url
tar -xf $fname --transform=s:^:$dir/:
install -Dt $prefix/bin $dir/hugo


case $(uname -m) in
x86_64) arch=x64;;
aarch64) arch=arm64;;
*) echo 'Unknown arch.'; exit 1;;
esac
ver=$(curl -fsSL https://api.github.com/repos/sass/dart-sass/releases/latest | grep -Po '(?<="tag_name": ")[0-9.]+(?=",)' | head -n1)
dir=dart-sass-$ver-linux-$arch
fname=$dir.tar.gz
url=https://github.com/sass/dart-sass/releases/download/$ver/$fname

echo 'Dart Sass'
echo "Installed:     $(sass --version 2>/dev/null || echo 'Not installed')"
echo "Remote latest: $ver"

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLO $url
tar -xf $fname --transform=s:^dart-sass:$dir:
mkdir -p $prefix/bin
ln -sf $prefix/src/$dir/sass $prefix/bin
