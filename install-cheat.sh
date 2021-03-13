#!/usr/bin/env bash
if [[ $(uname) == Darwin ]]; then
	os=darwin
else
	os=linux
fi
url=https://github.com$(wget -q -O - https://github.com/cheat/cheat/releases/latest | grep -Eo '/cheat/cheat/releases/download/[0-9.]+/cheat-'$os'-amd64\.gz')
fname=$(grep -Eo '[^/]+$' <<<$url)

cd /tmp
wget -q -O $fname $url
gzip -cd $fname > cheat
install -D -g 0 -o root -m 755 cheat /usr/local/bin/cheat
rm -f cheat
