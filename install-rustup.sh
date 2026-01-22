#!/bin/bash
set -euo pipefail

if ! type rustup &>/dev/null; then
	curl -fsS https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
	rustup update
fi

rustup component add rust-analyzer rust-src

dir=~/.local/share/bash-completion/completions
mkdir -p $dir
rustup completions bash >$dir/rustup
ln -sf "$(rustc --print sysroot)/etc/bash_completion.d/cargo" $dir/cargo

# cargo install evcxr_repl
