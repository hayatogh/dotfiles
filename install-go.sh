#!/usr/bin/env bash
. ~/dotfiles/install-helper.sh

os=linux
if [[ $(uname) == Darwin ]]; then
	os=darwin
fi
ver=$(wget -qO- https://golang.org/dl/ | grep -Po '(?<=/dl/go)[0-9.]+(?=\.'$os'-amd64\.tar\.gz)' | head -n1)
url=https://golang.org/dl/go$ver.$os-amd64.tar.gz
exe=go
local_ver() {
	go version | grep -Po '(?<=go)[0-9.]+'
}
install_func() {
	local tmp=$(mktemp_track)
	echo "Downloading"
	wget -qO $tmp $url
	echo "Deleting old goroot"
	rm -rf ~/.goroot
	echo "Extracting"
	tar -xf $tmp -C $HOME --transform=s/^go/.goroot/
	echo "Installed"
}

helper
