#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
if ! type -a rustup &>/dev/null; then
	curl -fsS https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
	rustup update
fi
rustup component add rust-analyzer rust-src
# curl -fsS https://wasmtime.dev/install.sh | bash

cargo install evcxr_repl runner

$dotfiles/getbashcompletion.sh rustup cargo
