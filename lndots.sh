#!/usr/bin/env bash
# mkdir to ensure 2nd argmment of ln exists when creating dir symlinks.
# rm dirs when creating dir symlinks because ln can't overwrite directorys
dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
uname=$(uname)

files=".inputrc .bash_profile .bashrc .gdbinit .infokey .vim .w3m .themes"
dirsinconfig="git yapf emacs latexmk cheat"

mkdir -p ~/.screen ~/.ssh ~/.config
chmod 700 ~/.screen ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

rm_ln()
{
	target=$1 linkname=$2
	rm -rf $linkname
	ln -s $target $linkname
}

if [[ $uname =~ NT-10\.0 ]]; then
	winhome=/c/Users/$USER
	windoc=$(cygpath $(powershell '[Environment]::GetFolderPath("MyDocuments")'))
	export MSYS=winsymlinks:nativestrict
	mkdir -p $winhome/.config

	rm_ln $dotfiles $winhome/$(basename $dotfiles)
	rm_ln $dotfiles/latexmk $winhome/.config/latexmk
	rm_ln $dotfiles/.vim $winhome/vimfiles
	rm_ln $dotfiles/mintty $APPDATA/mintty
	rm_ln $dotfiles/alacritty $APPDATA/alacritty
	rm_ln $dotfiles/WindowsPowerShell $windoc/WindowsPowerShell
elif [[ $uname == Darwin ]]; then
	dirsinconfig="$dirsinconfig karabiner hammerspoon"
elif [[ $(uname -r) =~ Microsoft ]]; then
	winhome=/mnt/c/Users/$(cut -d\\ -f3 <<<$APPDATA)
fi
if [[ -v winhome ]]; then
	rm_ln $winhome/Desktop ~/Desktop
	rm_ln $winhome ~/WinHome
fi
for fname in $files; do
	rm_ln $dotfiles/$fname ~/$fname
done
for dname in $dirsinconfig; do
	rm_ln $dotfiles/$dname ~/.config/$dname
done

cd $dotfiles
./getgitprompt.sh
