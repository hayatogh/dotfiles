#!/bin/bash
set -euo pipefail

prefix=~/.local
arch=$(uname -m)
ver=$(curl -fsSL https://api.github.com/repos/extrawurst/gitui/releases/latest | grep -Po '(?<="tag_name": "v)([0-9.]+)(?=",)' | head -n1)
fname=gitui-linux-$arch.tar.gz
url=https://github.com/extrawurst/gitui/releases/download/v$ver/$fname

echo "Installed:     $(gitui --version 2>/dev/null | grep -Po '(?<= )[0-9.]+$' || echo 'Not installed')"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLo $fname $url
tar -xf $fname
mkdir -p $prefix/bin
cp gitui $prefix/bin/gitui
