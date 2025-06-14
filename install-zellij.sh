#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=~/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

arch=$(uname -m)
ver=$(curl -fsSL https://api.github.com/repos/zellij-org/zellij/releases/latest | grep -Po '(?<="tag_name": "v)([0-9.]+)(?=",)' | head -n1)
fname=zellij-$arch-unknown-linux-musl.tar.gz
url=https://github.com/zellij-org/zellij/releases/latest/download/$fname

echo "Installed:     $(zellij --version 2>/dev/null | grep -Po '(?<= )[0-9.]+$' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLo $fname $url
tar -xf $fname
mkdir -p $prefix/bin
cp zellij $prefix/bin/zellij
mkdir -p $prefix/share/bash-completion/completions
zellij setup --generate-completion bash >$prefix/share/bash-completion/completions/zellij
