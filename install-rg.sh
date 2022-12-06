#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

use_deb=0
if grep -Pq '^ID=(debian|ubuntu)$' /etc/os-release 2>/dev/null; then
	use_deb=1
fi
arch=$(uname -m)
ver=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -Po '(?<=/BurntSushi/ripgrep/releases/download/)([0-9.]+)(?=/ripgrep_\1_amd64\.deb)' | head -n1)
if [[ $use_deb ]]; then
	fname=ripgrep_${ver}_amd64.deb
else
	dir=ripgrep-$ver-x86_64-unknown-linux-musl
	fname=$dir.tar.gz
fi
url=https://github.com/BurntSushi/ripgrep/releases/download/$ver/$fname

echo "Installed:     $(rg --version 2>/dev/null | grep -Po '(?<= )[0-9.]+$' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p /usr/local/src
cd /usr/local/src
curl -fsSLo $fname $url
if [[ $use_deb ]]; then
	dpkg -i $fname || apt -f install ripgrep
else
	tar -xf $fname
	cd $dir
	cp rg ../../bin/rg
	cp doc/rg.1 ../../share/man/man1/rg.1
	cp complete/rg.bash /etc/bash_completion.d/rg.bash
fi
