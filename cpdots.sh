#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
pspath() {
	wslpath "$(powershell.exe "$1" | tr -d '\r')"
}

winhome=$(pspath 'Get-Content Env:USERPROFILE')
windoc=$(pspath '[Environment]::GetFolderPath("MyDocuments")')
appdata=$(pspath 'Get-Content Env:APPDATA')
mkdir -p "$winhome"/.config

rsync -a --delete $dotfiles/latexmk/ "$winhome"/.config/latexmk
rsync -a --delete $dotfiles/.vimfx/ "$winhome"/.vimfx
rsync -a --delete $dotfiles/mintty/ "$appdata"/mintty
rsync -a --delete $dotfiles/alacritty/ "$appdata"/alacritty
rsync -a --delete $dotfiles/WindowsPowerShell/ "$windoc"/WindowsPowerShell
rsync -az --exclude=.git/ --exclude=/.netrwhist --exclude=/.viminfo --exclude=/swap --delete $dotfiles/.vim/ "$winhome"/vimfiles
