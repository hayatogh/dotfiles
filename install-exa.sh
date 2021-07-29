#!/usr/bin/env bash
. install-helper.sh

os=linux
ver=$(wget -qO- https://github.com/ogham/exa/releases/latest | grep -Po '(?<=/ogham/exa/releases/download/v)[0-9.]+(?=/exa-'$os'-x86_64-musl-v[0-9.]+\.zip)' | head -n1)
url=https://github.com/ogham/exa/releases/download/v$ver/exa-$os-x86_64-musl-v$ver.zip
exe=exa
local_ver() {
	$exe --version | grep -Po '(?<=v)[0-9.]+'
}
install_func() {
	local tmpd=$(mktemp_track -d)
	pushd $tmpd
	wget -qO exa.zip $url
	unzip -q exa.zip
	mv_file completions/exa.bash ~/.local/share/bash-completion/\${1%.bash}
	# completions/exa.zsh
	# completions/exa.fish
	mv_file man/exa.1 ~/.local/share/\$1
	mv_file man/exa_colors.5 ~/.local/share/\$1
	mv_file bin/exa ~/.local/\$1
	popd
}

helper
