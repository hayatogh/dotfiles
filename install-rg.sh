#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit
fi

ver=$(wget -qO- https://github.com/BurntSushi/ripgrep/releases/latest | grep -Po '(?<=/BurntSushi/ripgrep/releases/download/)([0-9.]+)(?=/ripgrep_\1_amd64\.deb)' | head -n1)
fname=ripgrep_${ver}_amd64.deb
url=https://github.com/BurntSushi/ripgrep/releases/download/$ver/$fname

loc="Not installed"
if type rg &>/dev/null; then
	loc=$(rg --version | grep -Po '(?<= )[0-9.]+(?= )' || true)
fi
echo "Installed:     $loc"
echo "Remote latest: $ver"

arg=${1:-}
if [[ $arg == -n || $loc == $ver && $arg != -f ]]; then
	exit
fi

mkdir -p /usr/local/src
cd /usr/local/src
wget -qO $fname $url
dpkg -i $fname
