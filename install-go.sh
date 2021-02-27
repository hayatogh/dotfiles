#!/usr/bin/env bash
if [[ $(uname) == Darwin ]]; then
	os=darwin
else
	os=linux
fi
if type -a go &>/dev/null; then
	version=$(go version | cut -d\  -f3)
else
	version=go0
fi
url=https://golang.org$(wget -q -O - https://golang.org/dl/ | grep -E -m1 -o '/dl/go([[:digit:]]+\.){2,3}'$os'-amd64\.tar.gz')
fname=$(grep -E -o '[^/]+$' <<<$url)

if [[ $1 == '-n' ]]; then
	echo "Installed:     $version"
	echo "Remote latest: $(sed 's/.'$os'-amd64.tar.gz//' <<<$fname)"
	echo "URL: $url"
	exit
fi

if [[ ! $fname =~ $version ]]; then
	cd /tmp
	echo "Downloading go"
	wget -q -O $fname $url
	echo "Deleting old goroot"
	rm -rf go ~/.goroot
	echo "Extracting"
	tar -xf $fname
	mv go ~/.goroot
	echo "Finishing"
	rm -f $fname
fi
