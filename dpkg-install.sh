#!/usr/bin/env bash
url=https://github.com$(wget -q -O - https://github.com/BurntSushi/ripgrep/releases/latest | grep -E -o '/BurntSushi/ripgrep/releases/download/[[:digit:].]+/ripgrep_[[:digit:].]+_amd64.deb')
fname=$(grep -E -o '[^/]+$' <<<$url)

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $fname $url
dpkg -i $fname
