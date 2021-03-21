#!/usr/bin/env bash
set -euo pipefail

dir=~/.local/share/bash-completion/completions
mkdir -p $dir
if type rustup &>/dev/null; then
	rustup completions bash >$dir/rustup
fi
wget -qO $dir/cargo https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/cargo.bashcomp.sh
if type pip3 &>/dev/null; then
	pip3 completion --bash >$dir/pip3
fi
