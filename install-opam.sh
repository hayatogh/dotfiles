#!/usr/bin/env bash
ARCH=$(uname -m || echo unknown)
case "$ARCH" in
	x86|i?86) ARCH="i686";;
	x86_64|amd64) ARCH="x86_64";;
	ppc|powerpc|ppcle) ARCH="ppc";;
	aarch64_be|aarch64) ARCH="arm64";;
	armv5*|armv6*|earmv6*|armv7*|earmv7*|armv8b|armv8l) ARCH="armhf";;
	*) ARCH=$(echo "$ARCH" | awk '{print tolower($0)}')
esac

OS=$( (uname -s || echo unknown) | awk '{print tolower($0)}')
if [ "$OS" = "darwin" ] ; then
	OS=macos
fi

if type -a opam &>/dev/null; then
	version=-$(opam --version)-
else
	version=-0-
fi

url=https://github.com$(wget -q -O - https://github.com/ocaml/opam/releases/latest | grep -Eom1 '/ocaml/opam/releases/download/[0-9.]+/opam-[0-9.]+-'$ARCH'-'$OS)
fname=$(grep -Eo '[^/]+$' <<<$url)

if [[ ! $fname =~ $version ]]; then
	cd /tmp
	wget -q -O $fname $url
	rm -rf ~/.opam
	sudo install -D -g 0 -o root -m 755 $fname /usr/local/bin/opam
	rm -f $fname
fi
