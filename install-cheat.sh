#!/usr/bin/env bash
set -euo pipefail

prefix=$HOME/.local

os=linux
ver=$(curl -fsSL https://api.github.com/repos/cheat/cheat/releases/latest | grep -Po '(?<=/cheat/cheat/releases/download/)[0-9.]+(?=/cheat-'$os'-amd64\.gz)' | head -n1)
url=https://github.com/cheat/cheat/releases/download/$ver/cheat-$os-amd64.gz

echo "Installed:     $(cheat --version 2>/dev/null | grep -Po '[0-9.]+' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

tmp=$(mktemp)
curl -fsSLo $tmp $url
mkdir -p $prefix/bin
gzip -cd $tmp >$prefix/bin/cheat
chmod 755 $prefix/bin/cheat
rm -rf ~/.config/cheat/cheatsheets/community
git clone --depth 1 -- https://github.com/cheat/cheatsheets ~/.config/cheat/cheatsheets/community &>/dev/null
rm $tmp
