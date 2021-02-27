#!/usr/bin/env bash
if [[ $(uname) == Darwin ]]; then
	os=darwin
else
	os=linux
fi
url=https://github.com$(wget -q -O - https://github.com/cheat/cheat/releases/latest | grep -E -o '/cheat/cheat/releases/download/[[:digit:].]+/cheat-'$os'-amd64\.gz')
fname=$(grep -E -o '[^/]+$' <<<$url)

cd /tmp
wget -q -O $fname $url
gzip -cd $fname > cheat
install -D -g 0 -o root -m 755 cheat /usr/local/bin/cheat
rm -f cheat
