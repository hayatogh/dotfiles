#!/usr/bin/env bash
dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
cd $dotfiles
./install-go.sh
cd
export GO111MODULE=on # for Go 1.15 or older
# go get gonum.org/v1/plot/...
go get golang.org/x/tools/gopls@latest
# go get golang.org/x/lint/golint
go get golang.org/x/tools/cmd/goimports
