#!/bin/bash
set -euo pipefail

_diffh()
{
	local backend=$1 l=$2 r=$3
	local base='sed -E '\''s:.*/::'\'' <<<'
	local root='sed -E '\''s:.*/::; s/(.+)\.[a-zA-Z0-9]+$/\1/'\'' <<<'
	local bl=$(eval $base$l)
	local br=$(eval $base$r)
	local rl=$(eval $root$l)
	local rr=$(eval $root$r)

	local title="diff $bl $br"
	local out="diff_${rl}_$rr.html"
	if [[ $rl == $rr ]]; then
		out="diff_$rl.html"
	fi
	_diffh_$backend
}

_diffh_d2hc()
{
	git diff --no-index --histogram -U2147483647 -- "$l" "$r" \
		| diff2html-cli -s side --su hidden -t "$title" -i stdin -o stdout | _d2hc_expand_links >"$out"
}

_d2hc_expand_links()
{
	local cachedir=~/.cache/diffh line href media cache
	mkdir -p $cachedir
	while read -r line; do
		if [[ $line =~ ^\<link\ rel=\"stylesheet\" ]]; then
			href=$(grep -Po '(?<=href=")[^"]+(?=")' <<<$line)
			cache=$cachedir/$(basename $href)
			if [[ ! -e $cache ]]; then
				curl -fsSLo $cache $href
			fi
			media=$(grep -Po '(?<=media=")[^"]+(?=")' <<<$line)
			echo -e "<style>\n@media $media {\n$(cat $cache)\n}\n</style>"
		else
			echo "$line"
		fi
	done
}

_diffh_winmerge()
{
	local winmerge='/mnt/c/Program Files/WinMerge/WinMergeU.exe'
	"$winmerge" -noninteractive -dl "$bl" -dr "$br" -or "$out" "$(wslpath -w "$l")" "$(wslpath -w "$r")"
}

_diffh "$@"
