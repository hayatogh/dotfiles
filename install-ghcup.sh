#!/usr/bin/env bash
set -euo pipefail

export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
export BOOTSTRAP_HASKELL_INSTALL_HLS=1
curl -fsS https://get-ghcup.haskell.org | sh
