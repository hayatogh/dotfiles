#!/bin/bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)

tohome=.bashrc
toconfig='gdb git gitui gtk-3.0/gtk.css lessfilter ptpython tmux vim/vimrc'

mkdir -p ~/.ssh ~/.config/vim/swap
chmod 700 ~/.ssh ~/.config/vim/swap
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
if [[ ! -e ~/.ssh/config ]]; then
	cp $dotfiles/ssh_config ~/.ssh/config
fi
userdirs=~/.config/user-dirs.dirs
rmdir_name()
{
	declare -n dir=$1
	if [[ $dir == $HOME/ || ! -d $dir ]]; then
		return
	fi
	rmdir --ignore-fail-on-non-empty "$dir"
}
mkdir_name()
{
	declare -n dir=$1
	if [[ -e $dir ]]; then
		return
	fi
	mkdir -p "$dir"
}
foreach_userdirs()
(
	local func=$1 n
	. $userdirs
	for n in XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR XDG_PROJECTS_DIR; do
		$func $n
	done
)
if grep '^XDG.*デスクトップ' $userdirs &>/dev/null; then
	foreach_userdirs rmdir_name
	sed -i 's/^XDG/#&/g' $userdirs
	cat >>$userdirs <<'EOF'
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/Desktop/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Desktop/Public"
XDG_DOCUMENTS_DIR="$HOME/Desktop/Documents"
XDG_MUSIC_DIR="$HOME/Desktop/Music"
XDG_PICTURES_DIR="$HOME/Desktop/Pictures"
XDG_VIDEOS_DIR="$HOME/Desktop/Videos"
XDG_PROJECTS_DIR="$HOME/Desktop/Projects"
EOF
	foreach_userdirs mkdir_name
fi
if [[ -f ~/.profile ]]; then
	printf '1{/return/!i\\\nif [ "$BASH_VERSION" ]; then . ~/.bashrc; return; fi\n}' | sed -i -f - ~/.profile
fi

rm_ln()
{
	(($# == 2)) || return 1
	local target=$1 linkname=$2
	rm -rf "$linkname"
	mkdir -p "$(dirname "$linkname")"
	ln -s "$target" "$linkname"
}

for fname in $tohome; do
	rm_ln $dotfiles/$fname ~/$fname
done
for fname in $toconfig; do
	rm_ln $dotfiles/$fname ~/.config/$fname
done
