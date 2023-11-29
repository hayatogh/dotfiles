#!/usr/bin/env bash
set -euo pipefail

prefix=/usr/local
if [[ ${1:-} == -l ]]; then
	prefix=$HOME/.local
fi

if [[ $EUID != 0 && $prefix == /usr/local ]]; then
	exec sudo "$0" "$@"
fi

use_deb=0
if grep -Pq '^ID=(debian|ubuntu)$' /etc/os-release 2>/dev/null; then
	use_deb=1
fi
ver=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | grep -Po '(?<=/sharkdp/fd/releases/download/v)([0-9.]+)(?=/fd_\1_amd64\.deb)' | head -n1)
binname=fd
if (( $use_deb )); then
	if type fdfind &>/dev/null; then
		binname=fdfind
	fi
	fname=fd_${ver}_amd64.deb
else
	dir=fd-v$ver-x86_64-unknown-linux-musl
	fname=$dir.tar.gz
fi
url=https://github.com/sharkdp/fd/releases/download/v$ver/$fname

echo "Installed:     $($binname --version 2>/dev/null | grep -Po '(?<= )[0-9.]+$' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi
if [[ $binname == fdfind ]]; then
	echo "You have to uninstall fd-find package to proceed installation. Exiting."
	exit 1
fi

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLo $fname $url
if (( $use_deb )); then
	dpkg -i $fname || apt -f install fd
else
	rm -rf $dir
	tar -xf $fname
	cd $dir
	mkdir -p $prefix/bin
	cp fd $prefix/bin/fd
	mkdir -p $prefix/share/man/man1
	cp fd.1 $prefix/share/man/man1/fd.1
	if [[ $EUID == 0 ]]; then
		mkdir -p /etc/bash_completion.d
		cp autocomplete/fd.bash /etc/bash_completion.d/fd.bash
	else
		mkdir -p $prefix/share/bash-completion/completions
		cp autocomplete/fd.bash $prefix/share/bash-completion/completions/fd.bash
	fi
fi
