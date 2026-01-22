#!/bin/bash
set -euo pipefail

if ! type deno &>/dev/null; then
	curl -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path
else
	deno upgrade
fi

deno install -g -RWES --deny-net npm:diff2html-cli
