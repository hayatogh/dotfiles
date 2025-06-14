#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=~/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

ver=$(curl -fsSL https://api.github.com/repos/extrawurst/gitui/releases/latest | grep -Po '(?<="tag_name": "v)([0-9.]+)(?=",)' | head -n1)
fname=gitui-linux-x86_64.tar.gz
url=https://github.com/extrawurst/gitui/releases/download/v$ver/$fname

echo "Installed:     $(gitui --version 2>/dev/null | grep -Po '(?<= )[0-9.]+$' || echo "Not installed")"
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
