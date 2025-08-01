#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
pspath() {
	wslpath "$(powershell.exe -NoProfile "$1" | tr -d '\r')"
}

winhome=$(pspath 'Get-Content Env:USERPROFILE')
windoc=$(pspath '[Environment]::GetFolderPath("MyDocuments")')
appdata=$(pspath 'Get-Content Env:APPDATA')
mkdir -p "$winhome/.config"

cp_mintty() {
	rsync -rt $dotfiles/mintty/ "$appdata/mintty/"
}
cp_powershell() {
	rsync -rt $dotfiles/PowerShell/ "$windoc/PowerShell/"
}
cp_vim() {
	rsync -rtz --exclude=.git/ --exclude=/.netrwhist --exclude=/.viminfo --exclude=/swap --delete $dotfiles/.vim/ "$winhome/vimfiles"
}
cp_vsvimrc() {
	rsync -rt $dotfiles/.vsvimrc "$winhome/"
}
cp_alacritty() {
	rsync -rt $dotfiles/alacritty/ "$appdata/alacritty/"
}
cp_latexmk() {
	rsync -rt $dotfiles/latexmk/ "$winhome/.config/latexmk/"
}

arg=(powershell)
if [[ $# -ne 0 ]]; then
	arg=("$@")
fi
for x in ${arg[@]}; do
	cp_${x}
done
