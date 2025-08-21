#!/bin/bash
set -euo pipefail

os=linux
ver=$(curl -fsS https://go.dev/dl/ | grep -Po '(?<=/dl/go)[0-9.]+(?=\.'$os'-amd64\.tar\.gz)' | head -n1)
url=https://golang.org/dl/go$ver.$os-amd64.tar.gz

echo "Installed:     $(go version 2>/dev/null | grep -Po '(?<=go)[0-9.]+' || echo "Not installed")"
echo "Remote latest: $ver"

if [[ ${1:-} == -n ]]; then
	exit
fi

tmp=$(mktemp)
curl -fsSo $tmp $url
rm -rf ~/.goroot
tar -xf $tmp -C ~ --transform=s/^go/.goroot/
rm -f $tmp
