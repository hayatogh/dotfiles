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
ver=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | grep -Po '(?<="tag_name": ")([0-9.]+)(?=",)' | head -n1)
if (( $use_deb )); then
	fname=git-delta-musl_${ver}_amd64.deb
else
	dir=delta-$ver-x86_64-unknown-linux-musl
	fname=$dir.tar.gz
fi
url=https://github.com/dandavison/delta/releases/download/$ver/$fname

echo "Installed:     $(delta --version 2>/dev/null | grep -Po '(?<= )[0-9.]+$' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

mkdir -p $prefix/src
cd $prefix/src
curl -fsSLo $fname $url
if (( $use_deb )); then
	dpkg -i $fname || apt -f install git-delta
else
	rm -rf $dir
	tar -xf $fname
	cd $dir
	mkdir -p $prefix/bin
	cp delta $prefix/bin/delta
fi
