#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
pspath() {
	wslpath "$(powershell.exe -NoProfile "$1" | tr -d '\r')"
}

winhome=$(pspath 'Get-Content Env:USERPROFILE')
windoc=$(pspath '[Environment]::GetFolderPath("MyDocuments")')
appdata=$(pspath 'Get-Content Env:APPDATA')
mkdir -p "$winhome"/.config

if [[ ${1:-} =~ |all ]]; then
	rsync -a --delete $dotfiles/.vimfx/ "$winhome/.vimfx"
	rsync -a --delete $dotfiles/.vsvimrc "$winhome/.vsvimrc"
	rsync -a --delete $dotfiles/PowerShell/ "$windoc/PowerShell"
	# rsync -a --delete $dotfiles/alacritty/ "$appdata/alacritty"
	# rsync -a --delete $dotfiles/latexmk/ "$winhome/.config/latexmk"
fi

if [[ ${1:-} =~ mintty|all ]]; then
	rsync -a --delete $dotfiles/mintty/ "$appdata/mintty"
fi
if [[ ${1:-} =~ vim|all ]]; then
	rsync -az --exclude=.git/ --exclude=/.netrwhist --exclude=/.viminfo --exclude=/swap --delete $dotfiles/.vim/ "$winhome/vimfiles"
fi
