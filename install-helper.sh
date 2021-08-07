#!/usr/bin/env bash
set -euo pipefail

if [[ ${with_sudo-} && $EUID != 0 ]]; then
	sudo "$0" "$@"
	exit
fi

_arg=${1:-}
_tempfiles=
if [[ ${with_sudo-} ]]; then
	mkdir -p /usr/local/src
else
	mkdir -p ~/.local/{bin,src}
fi

helper() {
	# $ver $url $exe local_ver() install_func()
	if [[ ! ( ${ver-} && ${exe-} && ${url-} && $(type -t local_ver 2>&1) == function && $(type -t install_func 2>&1) == function ) ]]; then
		exit 1
	fi

	local lver="Not installed"
	if type $exe &>/dev/null; then
		lver=$(local_ver || true)
	fi
	echo "Installed:     $lver"
	echo "Remote latest: $ver"

	if [[ $_arg == -n || $lver == $ver && $_arg != -f ]]; then
		exit
	fi

	install_func
	rm -rf $_tempfiles
}
mv_file() {
	local dst=$(eval echo $2)
	mkdir -p $(dirname $dst)
	mv $1 $dst
}
mktemp_track() {
	local tmp=$(mktemp "$@")
	_tempfiles="$_tempfiles $tmp"
	echo $tmp
}
git_clone() {
	if [[ $# == 2 ]]; then
		rm -rf $2
	else
		rm -rf $(basename $1)
	fi
	git clone --depth 1 -- $1 ${2:-} &>/dev/null
}
wget_tar_cd() {
	if [[ ! ${dir-} ]]; then
		exit 1
	fi
	local tmp=$(mktemp_track)
	cd $1
	wget -qO $tmp $url
	rm -rf $dir
	tar -xf $tmp
	cd $dir
}
mv_man() {
	mv_file $1 $2/man/man${1##*.}/$(basename $1)
}
