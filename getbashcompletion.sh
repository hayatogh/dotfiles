#!/bin/bash
set -euo pipefail

dir=~/.local/share/bash-completion/completions
mkdir -p $dir

rustup_comp() {
	type rustup &>/dev/null || return
	rustup completions bash >$dir/rustup
}
cargo_comp() {
	curl -fsSo $dir/cargo https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/cargo.bashcomp.sh
}
pip3_comp() {
	type pip3 &>/dev/null || return
	pip3 completion --bash >$dir/pip3
}

arg=(rustup cargo pip3)
if [[ $# -ne 0 ]]; then
	arg=("$@")
fi
for x in ${arg[@]}; do
	${x}_comp
done
