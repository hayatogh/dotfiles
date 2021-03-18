#!/usr/bin/env bash
dir=~/.local/share/bash-completion/completions
mkdir -p $dir
rustup completions bash >$dir/rustup
wget -qO $dir/cargo https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/cargo.bashcomp.sh
pip3 completion --bash >$dir/pip3
