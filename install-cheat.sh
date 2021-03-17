#!/usr/bin/env bash
os=linux
if [[ $(uname) == Darwin ]]; then
	os=darwin
fi
ver=$(wget -qO- https://github.com/cheat/cheat/releases/latest | grep -Po '(?<=/cheat/cheat/releases/download/)[0-9.]+(?=/cheat-'$os'-amd64\.gz)')
url=https://github.com/cheat/cheat/releases/download/$ver/cheat-$os-amd64.gz

msg=$(cheat --version 2>&1)
if [[ $? -ne 0 ]]; then
	msg="Not installed"
fi
echo "Installed:     $msg"
echo "Remote latest: $ver"

if [[ $1 == -n || $msg == $ver && $1 != -f ]]; then
	exit
fi

tmp=$(mktemp)
mkdir -p ~/.local/bin
wget -qO $tmp $url
gzip -cd $tmp > ~/.local/bin/cheat
chmod 755 ~/.local/bin/cheat
rm -f $tmp
