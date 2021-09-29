#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
wslpath() {
	/bin/wslpath "$1" | tr -d '\r'
}

winhome=$(wslpath "$(powershell.exe 'Get-Content Env:USERPROFILE')")
windoc=$(wslpath "$(powershell.exe '[Environment]::GetFolderPath("MyDocuments")')")
appdata=$(wslpath "$(powershell.exe 'Get-Content Env:APPDATA')")
mkdir -p "$winhome"/.config

rsync -a $dotfiles/latexmk/ "$winhome"/.config/latexmk
rsync -a $dotfiles/mintty/ "$appdata"/mintty
rsync -a $dotfiles/alacritty/ "$appdata"/alacritty
rsync -a $dotfiles/WindowsPowerShell/ "$windoc"/WindowsPowerShell
rsync -a --exclude=.git/ $dotfiles/.vim/ "$winhome"/vimfiles
