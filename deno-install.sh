#!/usr/bin/bash
set -euo pipefail

deno install -g -RWES --deny-net npm:diff2html-cli
