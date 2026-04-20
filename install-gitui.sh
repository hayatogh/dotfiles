#!/bin/bash
set -euo pipefail

prefix=~/.local
arch=$(uname -m)
ver=$(curl -fsSL https://api.github.com/repos/gitui-org/gitui/releases/latest | grep -Po '(?<="tag_name": "v)[0-9.]+(?=",)' | head -n1)
dir=gitui-linux-$arch
fname=gitui-linux-$arch.tar.gz
url=https://github.com/gitui-org/gitui/releases/download/v$ver/$fname

echo "Installed:     $(gitui --version 2>/dev/null | grep -Po '(?<= )[0-9.]+' || echo 'Not installed')"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLO $url
tar -xf $fname --transform=s:^:$dir/:
install -Dt $prefix/bin $dir/gitui
