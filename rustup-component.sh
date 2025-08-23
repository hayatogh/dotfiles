#!/bin/bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
if ! type -a rustup &>/dev/null; then
	curl -fsS https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
	rustup update
fi
rustup component add rust-analyzer rust-src
# curl -fsS https://wasmtime.dev/install.sh | bash

# cargo install evcxr_repl runner

dir=~/.local/share/bash-completion/completions
mkdir -p $dir
rustup completions bash >$dir/rustup
ln -sf "$(rustc --print sysroot)"/etc/bash_completion.d/cargo $dir/cargo
