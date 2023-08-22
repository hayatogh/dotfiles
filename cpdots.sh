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
	rsync -rt $dotfiles/.vimfx/ "$winhome/.vimfx"
	rsync -t $dotfiles/.vsvimrc "$winhome/.vsvimrc"
	rsync -rt $dotfiles/PowerShell/ "$windoc/PowerShell"
	# rsync -rt $dotfiles/alacritty/ "$appdata/alacritty"
	# rsync -rt $dotfiles/latexmk/ "$winhome/.config/latexmk"
fi

if [[ ${1:-} =~ mintty|all ]]; then
	rsync -rt $dotfiles/mintty/ "$appdata/mintty"
fi
if [[ ${1:-} =~ vim|all ]]; then
	rsync -rtz --exclude=.git/ --exclude=/.netrwhist --exclude=/.viminfo --exclude=/swap --delete $dotfiles/.vim/ "$winhome/vimfiles"
fi
