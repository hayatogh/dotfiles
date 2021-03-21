#!/usr/bin/env bash
set -euo pipefail

mintty=$(realpath $(dirname $0))
if [[ ! $(uname) =~ NT-10\.0 ]]; then
	echo "Couldn't installed. Run from MSYS."
	exit
fi

cd $mintty
rm -rf emojis
mkdir -p emojis
cd emojis

wget -qO getemojis https://github.com/mintty/mintty/wiki/getemojis
./getemojis -d windows
