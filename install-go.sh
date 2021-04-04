#!/usr/bin/env bash
set -euo pipefail

os=linux
if [[ $(uname) == Darwin ]]; then
	os=darwin
fi
ver=$(wget -qO- https://golang.org/dl/ | grep -Po '(?<=/dl/go)[0-9.]+(?=\.'$os'-amd64\.tar\.gz)' | head -n1)
url=https://golang.org/dl/go$ver.$os-amd64.tar.gz

loc="Not installed"
if type go &>/dev/null; then
	loc=$(go version | grep -Po '(?<=go)[0-9.]+' || true)
fi
echo "Installed:     $loc"
echo "Remote latest: $ver"

arg=${1:-""}
if [[ $arg == -n || $loc == $ver && $arg != -f ]]; then
	exit
fi

tmp=$(mktemp)
echo "Deleting old goroot"
rm -rf ~/.goroot
echo "Downloading"
wget -qO $tmp $url
echo "Extracting"
tar -xf $tmp -C $HOME --transform=s/^go/.goroot/
rm -f $tmp
