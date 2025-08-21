#!/bin/bash
set -euo pipefail

opam init -n
opam install -y ocaml-lsp-server ocamlformat utop
