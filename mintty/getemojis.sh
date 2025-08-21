#!/bin/bash
set -euo pipefail

mintty=$(wslpath "$(powershell.exe -NoProfile 'Get-Content Env:APPDATA' | tr -d '\r')")/mintty

cd $mintty
rm -rf emojis
mkdir emojis
cd emojis

curl -fsSLo getemojis https://github.com/mintty/mintty/raw/master/tools/getemojis
./getemojis -d google
