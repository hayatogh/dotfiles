#!/usr/bin/env bash
set -euo pipefail
# mkdir to ensure 2nd argmment of ln exists when creating dir symlinks.
# rm dirs when creating dir symlinks because ln can't overwrite directorys
dotfiles=$(realpath $(dirname $0))
_uname=$(uname -o 2>/dev/null || uname -s)
if [[ $_uname == GNU/Linux ]] && [[ $(uname -r) =~ [Mm]icrosoft ]]; then
	_uname=WSL
fi

files=".inputrc .bash_profile .bashrc .gdbinit .infokey .vim .themes"
dirsinconfig="git yapf latexmk cheat"

mkdir -p ~/.screen ~/.ssh ~/.config $dotfiles/.vim/swap
chmod 700 ~/.screen ~/.ssh $dotfiles/.vim/swap
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

rm_ln()
{
	target=$1 linkname=$2
	rm -rf "$linkname"
	ln -s "$target" "$linkname"
}
if [[ $_uname == Msys ]]; then
	export MSYS=winsymlinks:nativestrict
	winpath() {
		cygpath "$1"
	}
elif [[ $_uname == WSL ]]; then
	winpath() {
		wslpath "$1" | tr -d '\r'
	}
elif [[ $_uname == Darwin ]]; then
	dirsinconfig="$dirsinconfig karabiner"
fi

if [[ $_uname == Msys ]] || [[ $_uname == WSL ]]; then
	winhome=$(winpath "$(powershell.exe 'Get-Content Env:USERPROFILE')")
	windesk=$(winpath "$(powershell.exe '[Environment]::GetFolderPath("Desktop")')")
	onedrive=$(winpath "$(powershell.exe 'Get-Content Env:OneDrive')")
	rm_ln "$winhome" ~/WinHome
	rm_ln "$windesk" ~/Desktop
	rm_ln "$onedrive" ~/OneDrive
fi
for fname in $files; do
	rm_ln $dotfiles/$fname ~/$fname
done
for dname in $dirsinconfig; do
	rm_ln $dotfiles/$dname ~/.config/$dname
done
