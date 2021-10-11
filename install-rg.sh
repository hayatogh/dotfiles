#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

ver=$(curl -fsSL https://github.com/BurntSushi/ripgrep/releases/latest | grep -Po '(?<=/BurntSushi/ripgrep/releases/download/)([0-9.]+)(?=/ripgrep_\1_amd64\.deb)' | head -n1)
fname=ripgrep_${ver}_amd64.deb
url=https://github.com/BurntSushi/ripgrep/releases/download/$ver/$fname

echo "Installed:     $(rg --version 2>/dev/null | grep -Po '(?<= )[0-9.]+(?= )' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p /usr/local/src
cd /usr/local/src
curl -fsSo $fname $url
dpkg -i $fname
