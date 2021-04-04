#!/usr/bin/env bash
set -euo pipefail

os=linux
if [[ $(uname) == Darwin ]]; then
	os=darwin
fi
ver=$(wget -qO- https://github.com/cheat/cheat/releases/latest | grep -Po '(?<=/cheat/cheat/releases/download/)[0-9.]+(?=/cheat-'$os'-amd64\.gz)' | head -n1)
url=https://github.com/cheat/cheat/releases/download/$ver/cheat-$os-amd64.gz

loc="Not installed"
if type cheat &>/dev/null; then
	loc=$(cheat --version | grep -Po '[0-9.]+' || true)
fi
echo "Installed:     $loc"
echo "Remote latest: $ver"

arg=${1:-""}
if [[ $arg == -n || $loc == $ver && $arg != -f ]]; then
	exit
fi

tmp=$(mktemp)
mkdir -p ~/.local/bin
wget -qO $tmp $url
gzip -cd $tmp > ~/.local/bin/cheat
chmod 755 ~/.local/bin/cheat
rm -f $tmp

# setup
rm -rf ~/.config/cheat/cheatsheets/community
git clone --depth 1 -- git://github.com/cheat/cheatsheets ~/.config/cheat/cheatsheets/community &>/dev/null
