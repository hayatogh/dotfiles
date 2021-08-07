#!/usr/bin/env bash
. ~/dotfiles/install-helper.sh

os=linux
if [[ $(uname) == Darwin ]]; then
	os=darwin
fi
ver=$(wget -qO- https://github.com/cheat/cheat/releases/latest | grep -Po '(?<=/cheat/cheat/releases/download/)[0-9.]+(?=/cheat-'$os'-amd64\.gz)' | head -n1)
url=https://github.com/cheat/cheat/releases/download/$ver/cheat-$os-amd64.gz
exe=cheat
local_ver() {
	cheat --version | grep -Po '[0-9.]+'
}
install_func() {
	local tmp=$(mktemp_track)
	wget -qO $tmp $url
	gzip -cd $tmp > ~/.local/bin/cheat
	chmod 755 ~/.local/bin/cheat
	git_clone git://github.com/cheat/cheatsheets ~/.config/cheat/cheatsheets/community
}

helper
