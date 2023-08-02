#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
case $(uname -sr) in
	*icrosoft*) _uname=WSL;;
	*Linux*) _uname=Linux;;
	*Darwin*) _uname=Darwin;;
	*_NT*) _uname=MSYS;;
esac

tohome=".bash_profile .bashrc .gdbinit .vim .themes"
toconfig="git yapf latexmk cheat lessfilter"

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
		cygpath "$(powershell.exe -NoProfile "$1")"
	}
elif [[ $_uname == WSL ]]; then
	pspath() {
		wslpath "$(powershell.exe -NoProfile "$1" | tr -d '\r')"
	}
elif [[ $_uname == Darwin ]]; then
	toconfig="$toconfig karabiner"
fi

if [[ $_uname == MSYS ]] || [[ $_uname == WSL ]]; then
	winhome=$(pspath 'Get-Content Env:USERPROFILE')
	windesk=$(pspath '[Environment]::GetFolderPath("Desktop")')
	winbox="$winhome/Box Sync"
	rm_ln "$winhome" ~/WinHome
	rm_ln "$windesk" ~/Desktop
	rm_ln "$winbox" ~/Box
fi
for fname in $tohome; do
	rm_ln $dotfiles/$fname ~/$fname
done
for fname in $toconfig; do
	rm_ln $dotfiles/$fname ~/.config/$fname
done
