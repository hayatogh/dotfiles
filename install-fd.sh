#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

use_deb=0
if grep -Pq '^ID=(debian|ubuntu)$' /etc/os-release 2>/dev/null; then
	use_deb=1
fi
ver=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | grep -Po '(?<=/sharkdp/fd/releases/download/v)([0-9.]+)(?=/fd_\1_amd64\.deb)' | head -n1)
binname=fd
if [[ $use_deb ]]; then
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

mkdir -p /usr/local/src
cd /usr/local/src
curl -fsSLo $fname $url
if [[ $use_deb ]]; then
	dpkg -i $fname || apt -f install fd
else
	tar -xf $fname
	cd $dir
	cp fd ../../bin/fd
	cp fd.1 ../../share/man/man1/fd.1
	cp autocomplete/fd.bash /etc/bash_completion.d/fd.bash
fi
