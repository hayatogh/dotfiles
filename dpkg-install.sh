#!/usr/bin/env bash
url=https://github.com$(wget -q -O - https://github.com/BurntSushi/ripgrep/releases/latest | grep -Eo '/BurntSushi/ripgrep/releases/download/[0-9.]+/ripgrep_[0-9.]+_amd64\.deb')
fname=$(grep -Eo '[^/]+$' <<<$url)

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $fname $url
dpkg -i $fname
