#!/bin/bash
set -euo pipefail

case $(uname -m) in
x86_64)
	arch=amd64
	;;
aarch64)
	arch=arm64
	;;
*)
	echo 'Unknown arch.'
	exit 1
	;;
esac
ver=$(curl -fsS https://go.dev/dl/ | grep -Po '(?<=/dl/go)[0-9.]+(?=\.linux-'$arch'\.tar\.gz)' | head -n1)
url=https://golang.org/dl/go$ver.linux-$arch.tar.gz

echo "Installed:     $(go version 2>/dev/null | grep -Po '(?<=go)[0-9.]+' || echo 'Not installed')"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

tmp=$(mktemp)
curl -fsSo $tmp $url
rm -rf ~/.goroot
tar -xf $tmp -C ~ --transform=s/^go/.goroot/
rm -f $tmp
go install golang.org/x/tools/gopls@latest
