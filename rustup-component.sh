#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
if ! type -a rustup &>/dev/null; then
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
else
	rustup update
fi
rustup component add rls rust-analysis rust-src
# curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer && chmod +x ~/.local/bin/rust-analyzer
# curl https://wasmtime.dev/install.sh -sSf | bash

cargo install bindgen evcxr_repl runner

$dotfiles/getbashcompletion.sh rustup cargo
