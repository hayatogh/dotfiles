#!/bin/bash
set -euo pipefail

if ! type rustup &>/dev/null; then
	curl -fsS https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
	rustup update
fi

rustup component add rust-analyzer rust-src

# cargo install evcxr_repl
