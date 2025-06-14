#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=~/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

use_deb=0
if grep -Pqs '^ID=(debian|ubuntu)$' /etc/os-release; then
	use_deb=1
fi
arch=$(uname -m)
ver=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -Po '(?<="name": ")([0-9.]+)(?=",)' | head -n1)
if (( $use_deb )); then
	fname=ripgrep_$ver-1_amd64.deb
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

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLo $fname $url
if (( $use_deb )); then
	dpkg -i $fname || apt -f install ripgrep
else
	rm -rf $dir
	tar -xf $fname
	cd $dir
	mkdir -p $prefix/bin
	cp rg $prefix/bin/rg
	mkdir -p $prefix/share/man/man1
	cp doc/rg.1 $prefix/share/man/man1/rg.1
	mkdir -p $prefix/share/bash-completion/completions
	cp complete/rg.bash $prefix/share/bash-completion/completions/rg.bash
fi
