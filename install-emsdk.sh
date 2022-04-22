#!/usr/bin/env bash
set -euo pipefail

rm -rf ~/.emsdk
git clone --depth 1 -- https://github.com/emscripten-core/emsdk ~/.emsdk &>/dev/null
cd ~/.emsdk
./emsdk install latest
./emsdk activate latest
