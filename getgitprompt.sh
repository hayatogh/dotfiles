#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
wget -qO $dotfiles/git-prompt.sh https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
