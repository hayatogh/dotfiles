#!/usr/bin/env bash
dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
cd $dotfiles
./setupvim.sh
./setupcheat.sh
