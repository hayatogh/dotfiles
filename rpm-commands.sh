#!/bin/bash

alias rpmc='rpm -qp --changelog'

rpmt()
{
	[[ $# -eq 1 ]] || return 1
	rpm2cpio $1 | cpio -t --quiet
}

rpmi()
{
	[[ $# -lt 3 ]] || return 1
	local rpm=$1 base=${1##*/} pat tar
	if [[ ${2:-} ]]; then
		pat=$2
	elif [[ $base =~ ^kernel ]]; then
		pat=linux
	else
		pat=$(grep -Po '[a-z0-9]+(-[a-z]+)*' <<<$base | head -n1)
		[[ $pat ]] || return 1
	fi
	tar=$(rpmt $rpm | grep -Po '^'$pat'([-0-9.]+(\.(el|fc)[0-9_]+)?.tar.(xz|bz2|gz))?$')
	[[ $tar ]] || return 1
	rpm2cpio $rpm | cpio -idu --quiet $tar || return $?
	echo $tar
}

rpmia()
{
	[[ $# -eq 1 ]] || return 1
	local rpm=$(readlink -f $1) dir=$(basename $1 .rpm)
	mkdir $dir || return 1
	cd $dir
	rpm2cpio $rpm | cpio -idu --quiet
}
