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

rsync -a --delete $dotfiles/latexmk/ "$winhome/.config/latexmk"
rsync -a --delete $dotfiles/.vimfx/ "$winhome/.vimfx"
rsync -a --delete $dotfiles/mintty/ "$appdata/mintty"
rsync -a --delete $dotfiles/alacritty/ "$appdata/alacritty"
rsync -a --delete $dotfiles/PowerShell/ "$windoc/PowerShell"
rsync -az --exclude=.git/ --exclude=/.netrwhist --exclude=/.viminfo --exclude=/swap --delete $dotfiles/.vim/ "$winhome/vimfiles"
