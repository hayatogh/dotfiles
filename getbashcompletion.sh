#!/usr/bin/env bash
set -euo pipefail

dir=~/.local/share/bash-completion/completions
mkdir -p $dir
exists() {
	type $1 &>/dev/null
}

rustup_comp() {
	exists rustup || return
	rustup completions bash >$dir/rustup
}
cargo_comp() {
	curl -fsSo $dir/cargo https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/cargo.bashcomp.sh
}
pip3_comp() {
	exists pip3 || return
	pip3 completion --bash >$dir/pip3
}

arg=( rustup cargo pip3 )
if [[ $# -ne 0 ]]; then
	arg=( "$@" )
fi
for x in ${arg[@]}; do
	${x}_comp
done
