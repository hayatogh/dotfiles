#!/bin/bash
set -euo pipefail

if ! type uv &>/dev/null; then
	export UV_NO_MODIFY_PATH=1
	curl -fsSL https://astral.sh/uv/install.sh | sh
else
	uv self update
fi

uv tool install -U ruff
