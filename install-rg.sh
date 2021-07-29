#!/usr/bin/env bash
with_sudo=1
. install-helper.sh

ver=$(wget -qO- https://github.com/BurntSushi/ripgrep/releases/latest | grep -Po '(?<=/BurntSushi/ripgrep/releases/download/)([0-9.]+)(?=/ripgrep_\1_amd64\.deb)' | head -n1)
fname=ripgrep_${ver}_amd64.deb
url=https://github.com/BurntSushi/ripgrep/releases/download/$ver/$fname
exe=rg
local_ver() {
	rg --version | grep -Po '(?<= )[0-9.]+(?= )'
}
install_func() {
	cd /usr/local/src
	wget -qO $fname $url
	dpkg -i $fname
}

helper
