#!/bin/bash
set -m
shopt -s nullglob
export GIT_TERMINAL_PROMPT=0
export GIT_HTTP_LOW_SPEED_LIMIT=1000
export GIT_HTTP_LOW_SPEED_TIME=30
export GIT_SSH_COMMAND='ssh -o BatchMode=yes' # In case of Git config insteadOf set

dest=~/.config/vim/pack/remote/start
njobs=4
limit=20
tries=3
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

retry()
{
	local n rc
	for ((n = 1; n <= tries; n++)); do
		timeout "$limit" "$@" &>/dev/null </dev/null && return 0
		rc=$?
		echo >&2 " Retry($rc) $plug"
		sleep "$((1 + RANDOM % 3))"
	done
	return "$rc"
}

update()
{
	local plug=$1 url dir ret
	dir=$(to_dir "$plug")

	if [[ -d "$dir" ]]; then
		echo >&2 "Fetch $plug"
		retry git -C "$dir" fetch --depth 1 \
			&& git -C "$dir" reset --hard FETCH_HEAD &>/dev/null </dev/null
		ret=$?
	else
		echo >&2 "Clone $plug"
		url=$(to_url "$plug")
		retry git clone --depth 1 -- "$url" "$dir"
		ret=$?
	fi
	if (($ret)); then
		echo >&2 " Error($ret) $plug"
	else
		echo >&2 " Done $plug"
	fi
}
update_all()
{
	local i
	for i in "${!plugs[@]}"; do
		(( i >= njobs )) && wait -n
		(( i > 0 && i < njobs )) && sleep 0.5
		update "${plugs[i]}" </dev/null &
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
