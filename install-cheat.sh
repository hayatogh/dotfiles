#!/usr/bin/env bash
set -euo pipefail

os=linux
ver=$(curl -fsSL https://github.com/cheat/cheat/releases/latest | grep -Po '(?<=/cheat/cheat/releases/download/)[0-9.]+(?=/cheat-'$os'-amd64\.gz)' | head -n1)
url=https://github.com/cheat/cheat/releases/download/$ver/cheat-$os-amd64.gz

echo "Installed:     $(cheat --version 2>/dev/null | grep -Po '[0-9.]+' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

tmp=$(mktemp)
curl -fsSo $tmp $url
mkdir -p ~/.local/bin
gzip -cd $tmp >~/.local/bin/cheat
chmod 755 ~/.local/bin/cheat
rm -rf ~/.config/cheat/cheatsheets/community
git clone --depth 1 -- git://github.com/cheat/cheatsheets ~/.config/cheat/cheatsheets/community &>/dev/null
rm $tmp
