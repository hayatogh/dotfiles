#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID != 0 ]]; then
	exec sudo "$0" "$@"
fi

distro=$(grep -Po '(?<=^ID=).*$' /etc/os-release 2>/dev/null || echo "Unknown")
ver=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | grep -Po '(?<=/dandavison/delta/releases/download/)([0-9.]+)(?=/git-delta_\1_amd64\.deb)' | head -n1)
if [[ $distro =~ debian|ubuntu ]]; then
	fname=git-delta_${ver}_amd64.deb
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

mkdir -p /usr/local/src
cd /usr/local/src
curl -fsSLo $fname $url
if [[ $distro =~ debian|ubuntu ]]; then
	dpkg -i $fname
else
	tar -xf $fname
	cd $dir
	cp delta ../../bin/delta
fi
