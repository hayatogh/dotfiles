#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
if ! type -a rustup &>/dev/null; then
	curl -fsS https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
	rustup update
fi
rustup component add rls rust-analysis rust-src
# curl -fsSLo ~/.local/bin/rust-analyzer https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux && chmod +x ~/.local/bin/rust-analyzer
# curl -fsS https://wasmtime.dev/install.sh | bash

cargo install bindgen evcxr_repl runner

$dotfiles/getbashcompletion.sh rustup cargo
