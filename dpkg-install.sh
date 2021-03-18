#!/usr/bin/env bash
if [[ $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit $?
fi

url=https://github.com$(wget -qO- https://github.com/BurntSushi/ripgrep/releases/latest | grep -Eo '/BurntSushi/ripgrep/releases/download/[0-9.]+/ripgrep_[0-9.]+_amd64\.deb')
fname=$(grep -Eo '[^/]+$' <<<$url)

mkdir -p /usr/local/src
cd /usr/local/src
wget -qO $fname $url
dpkg -i $fname
