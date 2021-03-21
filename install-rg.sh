#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit
fi

ver=$(wget -qO- https://github.com/BurntSushi/ripgrep/releases/latest | grep -Po '(?<=/BurntSushi/ripgrep/releases/download/)([0-9.]+)(?=/ripgrep_\1_amd64\.deb)')
fname=ripgrep_${ver}_amd64.deb
url=https://github.com/BurntSushi/ripgrep/releases/download/$ver/$fname

loc=$(rg --version |& grep -Po '(?<= )[0-9.]+(?= )' || true)
if [[ -z $loc ]]; then
	loc="Not installed"
fi
echo "Installed:     $loc"
echo "Remote latest: $ver"

arg=${1:-""}
if [[ $arg == -n || $loc == $ver && $arg != -f ]]; then
	exit
fi

mkdir -p /usr/local/src
cd /usr/local/src
wget -qO $fname $url
dpkg -i $fname
