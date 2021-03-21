#!/usr/bin/env bash
set -euo pipefail

cd
export GO111MODULE=on # for Go 1.15 or older
# go get gonum.org/v1/plot/...
go get golang.org/x/tools/gopls@latest
# go get golang.org/x/lint/golint
go get golang.org/x/tools/cmd/goimports
