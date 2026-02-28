#!/bin/bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
case $(uname -sr) in
*icrosoft*)
	_uname=WSL;;
*Linux*)
	_uname=Linux;;
*_NT*)
	if [[ -x /usr/bin/pacman ]]; then
		_uname=MSYS
	else
		_uname=GITBASH
	fi;;
*)
	_uname=Other;;
esac

tohome=".bash_profile .bashrc"
toconfig="gdb git gitui gtk-3.0/gtk.css lessfilter tmux vim/vimrc"

mkdir -p ~/.ssh ~/.config/vim/swap
chmod 700 ~/.ssh ~/.config/vim/swap
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

rm_ln()
{
	(($# == 2)) || return 1
	local target=$1 linkname=$2
	rm -rf "$linkname"
	mkdir -p "$(dirname "$linkname")"
	ln -s "$target" "$linkname"
}

platformcmd=
case $_uname in
MSYS|WSL)
	nt()
	{
		[[ ${winhome:-} ]] || return 1
		rm_ln "$winhome" ~/WinHome
		rm_ln "$winhome/Downloads" ~/Downloads
	}
	platformcmd="nt ;"
	;;&
GITBASH|MSYS|WSL)
	ntcloud()
	{
		[[ ${wincloud:-} ]] || return 1
		rm_ln "$wincloud" ~/Drive
	}
	platformcmd="$platformcmd ntcloud ;"
	;;&
GITBASH|MSYS)
	export MSYS=winsymlinks:nativestrict
	winhome=$(cygpath "$(powershell.exe -NoProfile 'Get-Content Env:USERPROFILE')")
	wincloud=/g/マイドライブ
	;;
WSL)
	winhome=$(wslpath "$(powershell.exe -NoProfile 'Get-Content Env:USERPROFILE' | tr -d '\r')")
	wincloud=/mnt/g/マイドライブ
	wsl()
	{
		sudo cp $dotfiles/wsl/wsl.conf /etc/wsl.conf
		sudo cp $dotfiles/wsl/fstab /etc/fstab
	}
	platformcmd="$platformcmd wsl"
	;;
esac

eval "$platformcmd"
for fname in $tohome; do
	rm_ln $dotfiles/$fname ~/$fname
done
for fname in $toconfig; do
	rm_ln $dotfiles/$fname ~/.config/$fname
done
