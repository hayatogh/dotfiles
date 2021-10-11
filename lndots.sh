#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
case $(uname -sr) in
	*icrosoft*) _uname=WSL;;
	*Linux*) _uname=Linux;;
	*Darwin*) _uname=Darwin;;
	*_NT*) _uname=MSYS;;
esac

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
if [[ $_uname == MSYS ]]; then
	export MSYS=winsymlinks:nativestrict
	pspath() {
		cygpath "$(powershell.exe "$1")"
	}
elif [[ $_uname == WSL ]]; then
	pspath() {
		wslpath "$(powershell.exe "$1" | tr -d '\r')"
	}
elif [[ $_uname == Darwin ]]; then
	dirsinconfig="$dirsinconfig karabiner"
fi

if [[ $_uname == MSYS ]] || [[ $_uname == WSL ]]; then
	winhome=$(pspath 'Get-Content Env:USERPROFILE')
	windesk=$(pspath '[Environment]::GetFolderPath("Desktop")')
	onedrive=$(pspath 'Get-Content Env:OneDrive')
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
