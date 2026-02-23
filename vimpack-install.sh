#!/bin/bash
shopt -s nullglob
export GIT_TERMINAL_PROMPT=0
export GIT_HTTP_LOW_SPEED_LIMIT=1000
export GIT_HTTP_LOW_SPEED_TIME=30

dest=~/.config/vim/pack/remote/start
njobs=4
plugs=(
	"gh:tpope/vim-commentary"
	"gh:tpope/vim-eunuch"
	"gh:tommcdo/vim-lion"
	"gh:preservim/nerdtree"
	"gh:luochen1990/rainbow"
	"gh:hayatogh/vim-surround"
	# external commands
	"gh:dense-analysis/ale"
	"gh:HiPhish/info.vim"
	# libraries
	# "gh:kana/vim-operator-user"
	"gh:kana/vim-textobj-indent"
	"gh:kana/vim-textobj-user"
	"gh:hayatogh/vim-bash-completion"
	# colorscheme
	"gh:tomasr/molokai"
	# syntax and filetype plugins
	"gh:HealsCodes/vim-gas"
	# "gh:kchmck/vim-coffee-script"
)

to_url()
{
	sed 's|^gh:|https://github.com/|' <<<$1
}
to_dir()
{
	echo "$dest/${1##*/}"
}

update()
{
	local plug=$1 url dir ret
	dir=$(to_dir "$plug")

	if [[ -d "$dir" ]]; then
		echo >&2 "Fetch $plug"
		git -C "$dir" fetch --depth 1 &>/dev/null </dev/null \
			&& git -C "$dir" reset --hard FETCH_HEAD &>/dev/null </dev/null
		ret=$?
	else
		echo >&2 "Clone $plug"
		url=$(to_url "$plug")
		git clone --depth 1 -- "$url" "$dir" &>/dev/null </dev/null
		ret=$?
	fi
	if [[ $ret -eq 0 ]]; then
		echo >&2 " Done $plug"
	else
		echo >&2 " Error($ret) $plug"
	fi
}
update_all()
{
	local i
	for i in "${!plugs[@]}"; do
		(( i >= njobs )) && wait -n
		update "${plugs[i]}" &
	done
	wait
}
clean()
{
	local -A expected
	local p
	for p in "${plugs[@]}"; do
		expected[${p##*/}]=1
	done

	local dir
	for dir in "$dest"/*; do
		p=${dir##*/}
		if [[ -z ${expected[$p]} ]]; then
			echo >&2 "Clean $p"
			rm -rf "$dir"
		fi
	done
}
helptags()
{
	vim -Nesi NONE '+helptags ALL' '+q'
}

main()
{
	mkdir -p "$dest"
	update_all
	clean
	helptags
}

main
