#!/usr/bin/env bash
os=linux
if [[ $(uname) == Darwin ]]; then
	os=darwin
fi
ver=$(wget -qO- https://golang.org/dl/ | grep -Pom1 '(?<=/dl/go)[0-9.]+(?=\.'$os'-amd64\.tar\.gz)')
url=https://golang.org/dl/go$ver.$os-amd64.tar.gz

msg=$(go version |& grep -Po '(?<=go)[0-9.]+')
if [[ $? -ne 0 ]]; then
	msg="Not installed"
fi
echo "Installed:     $msg"
echo "Remote latest: $ver"

if [[ $1 == -n || $msg == $ver && $1 != -f ]]; then
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
