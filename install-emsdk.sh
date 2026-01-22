#!/bin/bash
set -euo pipefail

if [[ ! -d ~/.emsdk ]]; then
	git clone --depth 1 -- https://github.com/emscripten-core/emsdk ~/.emsdk &>/dev/null
else
	git -C ~/.emsdk pull &>/dev/null
fi
cd ~/.emsdk
./emsdk install latest
./emsdk activate latest
