#!/bin/bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)

tohome=.bashrc
toconfig='gdb git gitui gtk-3.0/gtk.css lessfilter tmux vim/vimrc'

mkdir -p ~/.ssh ~/.config/vim/swap
chmod 700 ~/.ssh ~/.config/vim/swap
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
if [[ ! -e ~/.ssh/config ]]; then
	cp $dotfiles/ssh_config ~/.ssh/config
fi
if [[ -d ~/ダウンロード && ! -e ~/Downloads ]]; then
	ln -s ~/ダウンロード ~/Downloads
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
