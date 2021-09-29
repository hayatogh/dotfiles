#!/usr/bin/env bash
set -euo pipefail

wslpath() {
	/bin/wslpath "$1" | tr -d '\r'
}
mintty=$(wslpath "$(powershell.exe 'Get-Content Env:APPDATA')")/mintty

cd $mintty
rm -rf emojis
mkdir emojis
cd emojis

wget -qO getemojis https://github.com/mintty/mintty/raw/master/tools/getemojis
./getemojis -d windows
